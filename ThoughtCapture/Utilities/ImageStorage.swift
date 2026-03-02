import UIKit

enum ImageStorage {
    static func saveToDocuments(_ image: UIImage, compressionQuality: CGFloat = 0.8) -> String? {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let url = URL.documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            return fileName
        } catch {
            return nil
        }
    }
}
