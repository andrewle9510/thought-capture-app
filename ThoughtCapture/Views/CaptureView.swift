import SwiftUI
import PhotosUI
import SwiftData

struct CaptureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appearanceConfig) private var config

    @Binding var isPresented: Bool

    @State private var text = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var loadedImages: [UIImage] = []
    @FocusState private var isTextFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Text input area
            textInputArea

            if !loadedImages.isEmpty {
                photoThumbnails
            }

            // Bottom toolbar
            bottomToolbar
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: config.captureCornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 12, y: -4)
        .onChange(of: isPresented) { _, newValue in
            if newValue {
                isTextFocused = true
            }
        }
        .onChange(of: selectedPhotos) { loadSelectedPhotos() }
    }

    // MARK: - Subviews

    private var textInputArea: some View {
        TextField("New note", text: $text, axis: .vertical)
            .font(.system(size: config.editingEntryFontSize))
            .focused($isTextFocused)
            .lineLimit(1...12)
            .padding(.horizontal, config.captureTextHorizontalPadding)
            .padding(.top, config.captureTextTopPadding)
            .padding(.bottom, config.captureTextBottomPadding)
    }

    private var photoThumbnails: some View {
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
            .padding(.vertical, 6)
        }
    }

    private var bottomToolbar: some View {
        HStack(spacing: config.captureToolbarSpacing) {
            Button { /* hashtag action */ } label: {
                Image(systemName: "number")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Button { /* reminder action */ } label: {
                Image(systemName: "bell")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            PhotosPicker(
                selection: $selectedPhotos,
                maxSelectionCount: 10,
                matching: .images
            ) {
                Image(systemName: "photo")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Mic / send button
            if canSave {
                Button(action: saveThread) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: config.captureSendButtonSize))
                        .foregroundStyle(.tint)
                }
            } else {
                Button { /* voice capture */ } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: config.captureMicButtonSize))
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal, config.captureToolbarHorizontalPadding)
        .padding(.vertical, config.captureToolbarVerticalPadding)
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
            if let fileName = ImageStorage.saveToDocuments(image) {
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

        // Reset and dismiss
        text = ""
        loadedImages = []
        selectedPhotos = []
        isPresented = false
    }

}
