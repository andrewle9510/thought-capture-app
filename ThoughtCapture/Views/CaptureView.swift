import SwiftUI
import PhotosUI
import SwiftData

struct CaptureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var loadedImages: [UIImage] = []
    @FocusState private var isTextFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                textInputArea

                if !loadedImages.isEmpty {
                    photoThumbnails
                }

                Divider()

                bottomToolbar
            }
            .navigationTitle("New Thought")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveThread() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .onAppear { isTextFocused = true }
            .onChange(of: selectedPhotos) { loadSelectedPhotos() }
        }
    }

    // MARK: - Subviews

    private var textInputArea: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($isTextFocused)
                .padding(.horizontal, 12)
                .padding(.top, 8)

            if text.isEmpty {
                Text("What's on your mind?")
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 17)
                    .padding(.top, 16)
                    .allowsHitTesting(false)
            }
        }
    }

    private var photoThumbnails: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(loadedImages.indices, id: \.self) { index in
                    Image(uiImage: loadedImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private var bottomToolbar: some View {
        HStack {
            PhotosPicker(
                selection: $selectedPhotos,
                maxSelectionCount: 10,
                matching: .images
            ) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.title3)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Logic

    private var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !loadedImages.isEmpty
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

    private func saveThread() {
        let thread = ThoughtThread()

        var fileNames: [String] = []
        for image in loadedImages {
            if let fileName = saveImageToDocuments(image) {
                fileNames.append(fileName)
            }
        }

        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = ThreadEntry(
            text: trimmedText.isEmpty ? nil : trimmedText,
            photoFileNames: fileNames
        )
        thread.entries.append(entry)

        modelContext.insert(thread)
        dismiss()
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
}
