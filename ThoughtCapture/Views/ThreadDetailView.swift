import SwiftUI
import PhotosUI
import SwiftData

struct ThreadDetailView: View {
    @Bindable var thread: ThoughtThread
    @State private var inputText = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var newImages: [UIImage] = []
    @State private var existingPhotoFileNames: [String] = []
    @State private var editingEntry: ThreadEntry?
    @FocusState private var isInputFocused: Bool
    @Environment(\.appearanceConfig) private var config

    private var isEditing: Bool { editingEntry != nil }

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
                    .padding(config.showDetailContainer ? config.containerPadding : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        if config.showDetailContainer {
                            RoundedRectangle(cornerRadius: config.containerCornerRadius)
                                .fill(Color(.secondarySystemBackground))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, config.detailTopSpacing)
                }
            }

            Divider()

            inputBar
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

    // MARK: - Input Bar

    private var inputBar: some View {
        VStack(spacing: 8) {
            if isEditing {
                HStack {
                    Text("Editing entry")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button("Cancel") { cancelEditing() }
                        .font(.caption)
                        .foregroundStyle(.tint)
                }
                .padding(.horizontal, 20)
            }

            if !existingPhotoFileNames.isEmpty || !newImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(existingPhotoFileNames, id: \.self) { fileName in
                            ThumbnailView(fileName: fileName, size: 60)
                        }
                        ForEach(newImages.indices, id: \.self) { index in
                            Image(uiImage: newImages[index])
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

                TextField(isEditing ? "Edit entry" : "Add to thread", text: $inputText, axis: .vertical)
                    .font(.system(size: config.editingEntryFontSize))
                    .lineLimit(1...8)
                    .focused($isInputFocused)
                    .onSubmit { submitInput() }

                if canSend {
                    Button(action: submitInput) {
                        Image(systemName: isEditing ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.tint)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
        .background(.bar)
    }

    // MARK: - Entry Content

    @ViewBuilder
    private func entryContent(_ entry: ThreadEntry) -> some View {
        VStack(alignment: .leading, spacing: config.paragraphSpacing) {
            HStack(alignment: .top) {
                if let text = entry.text {
                    Text(text)
                        .font(.system(size: config.entryFontSize))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Text(formattedTimestamp(entry.createdAt))
                    .font(.system(size: config.timestampFontSize))
                    .foregroundStyle(.secondary)
            }

            if !entry.photoFileNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(entry.photoFileNames, id: \.self) { fileName in
                            ThumbnailView(fileName: fileName, size: 120)
                        }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { startEditing(entry) }
    }

    // MARK: - Logic

    private var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !newImages.isEmpty || !existingPhotoFileNames.isEmpty
    }

    private func startEditing(_ entry: ThreadEntry) {
        editingEntry = entry
        inputText = entry.text ?? ""
        existingPhotoFileNames = entry.photoFileNames
        newImages = []
        selectedPhotos = []
        isInputFocused = true
    }

    private func cancelEditing() {
        editingEntry = nil
        inputText = ""
        selectedPhotos = []
        newImages = []
        existingPhotoFileNames = []
        isInputFocused = false
    }

    private func submitInput() {
        guard canSend else { return }

        if let entry = editingEntry {
            updateEntry(entry)
        } else {
            createEntry()
        }
    }

    private func updateEntry(_ entry: ThreadEntry) {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        entry.text = trimmed.isEmpty ? nil : trimmed

        var fileNames = existingPhotoFileNames
        for image in newImages {
            if let fileName = saveImageToDocuments(image) {
                fileNames.append(fileName)
            }
        }
        entry.photoFileNames = fileNames
        thread.updatedAt = Date()

        editingEntry = nil
        inputText = ""
        selectedPhotos = []
        newImages = []
        existingPhotoFileNames = []
        isInputFocused = false
    }

    private func createEntry() {
        var fileNames: [String] = []
        for image in newImages {
            if let fileName = saveImageToDocuments(image) {
                fileNames.append(fileName)
            }
        }

        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = ThreadEntry(
            text: trimmed.isEmpty ? nil : trimmed,
            photoFileNames: fileNames
        )
        thread.entries.append(entry)
        thread.updatedAt = Date()

        inputText = ""
        selectedPhotos = []
        newImages = []
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
            if isEditing {
                newImages.append(contentsOf: images)
            } else {
                newImages = images
            }
        }
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
