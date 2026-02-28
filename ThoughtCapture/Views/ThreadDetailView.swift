import SwiftUI
import PhotosUI
import SwiftData

struct ThreadDetailView: View {
    @Bindable var thread: ThoughtThread
    @State private var appendText = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var loadedImages: [UIImage] = []
    @FocusState private var isInputFocused: Bool

    private var sortedEntries: [ThreadEntry] {
        thread.entries.sorted { $0.createdAt < $1.createdAt }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                if sortedEntries.isEmpty {
                    ContentUnavailableView(
                        "No Entries",
                        systemImage: "text.bubble",
                        description: Text("Type below to add your first entry")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
                } else {
                    EntryTimeline(entries: sortedEntries) { entry in
                        entryContent(entry)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                }
            }

            Divider()

            appendBar
        }
        .navigationTitle("Thread")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    thread.isStarred.toggle()
                } label: {
                    Image(systemName: thread.isStarred ? "star.fill" : "star")
                        .foregroundStyle(thread.isStarred ? .yellow : .secondary)
                }
            }
        }
        .onChange(of: selectedPhotos) { loadSelectedPhotos() }
    }

    // MARK: - Append Bar

    private var appendBar: some View {
        VStack(spacing: 8) {
            if !loadedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(loadedImages.indices, id: \.self) { index in
                            Image(uiImage: loadedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            HStack(spacing: 10) {
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 10,
                    matching: .images
                ) {
                    Image(systemName: "photo")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                TextField("Add to thread", text: $appendText)
                    .focused($isInputFocused)
                    .onSubmit { appendEntry() }

                if canSend {
                    Button(action: appendEntry) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.tint)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground), in: Capsule())
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
        .background(.bar)
    }

    // MARK: - Entry Content

    @ViewBuilder
    private func entryContent(_ entry: ThreadEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                if let text = entry.text {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Text(formattedTimestamp(entry.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
        }
    }

    // MARK: - Logic

    private var canSend: Bool {
        !appendText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !loadedImages.isEmpty
    }

    private func appendEntry() {
        guard canSend else { return }

        var fileNames: [String] = []
        for image in loadedImages {
            if let fileName = saveImageToDocuments(image) {
                fileNames.append(fileName)
            }
        }

        let trimmedText = appendText.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = ThreadEntry(
            text: trimmedText.isEmpty ? nil : trimmedText,
            photoFileNames: fileNames
        )
        thread.entries.append(entry)
        thread.updatedAt = Date()

        appendText = ""
        selectedPhotos = []
        loadedImages = []
    }

    private func loadSelectedPhotos() {
        Task {
            var images: [UIImage] = []
            for item in selectedPhotos {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }
            loadedImages = images
        }
    }

    private func loadImage(named fileName: String) -> UIImage? {
        let url = URL.documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let url = URL.documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            return fileName
        } catch {
            return nil
        }
    }

    private func formattedTimestamp(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return date.formatted(.dateTime.hour().minute())
        } else {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
    }
}
