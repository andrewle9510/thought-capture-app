import SwiftUI
import SwiftData

struct ThreadDetailView: View {
    let thread: ThoughtThread

    var body: some View {
        List {
            ForEach(thread.entries.sorted { $0.createdAt < $1.createdAt }) { entry in
                EntryRow(entry: entry)
            }
        }
        .navigationTitle("Thread")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EntryRow: View {
    let entry: ThreadEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let text = entry.text {
                Text(text)
            }

            if !entry.photoFileNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.photoFileNames, id: \.self) { fileName in
                            if let image = loadImage(named: fileName) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                        }
                    }
                }
            }

            Text(entry.createdAt, style: .relative)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func loadImage(named fileName: String) -> UIImage? {
        let url = URL.documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
