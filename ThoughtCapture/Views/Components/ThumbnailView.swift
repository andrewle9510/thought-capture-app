import SwiftUI

struct ThumbnailView: View {
    let fileName: String
    let size: CGFloat

    @State private var image: UIImage?
    @Environment(\.displayScale) private var displayScale

    private var pixelSize: CGFloat { size * displayScale }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(.rect(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: size, height: size)
            }
        }
        .task(id: fileName) {
            image = await Self.cache.thumbnail(for: fileName, maxPixels: pixelSize)
        }
    }

    // MARK: - Shared Cache

    private static let cache = ThumbnailCache()
}

private actor ThumbnailCache {
    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()

    func thumbnail(for fileName: String, maxPixels: CGFloat) -> UIImage? {
        let cacheKey = "\(fileName)_\(Int(maxPixels))" as NSString
        if let cached = cache.object(forKey: cacheKey) { return cached }

        let url = URL.documentsDirectory.appendingPathComponent(fileName)
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }

        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: maxPixels,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCache: false
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }

        let thumbnail = UIImage(cgImage: cgImage)
        cache.setObject(thumbnail, forKey: cacheKey)
        return thumbnail
    }
}
