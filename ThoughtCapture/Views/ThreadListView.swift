import SwiftUI
import SwiftData

struct ThreadListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ThoughtThread.updatedAt, order: .reverse) private var threads: [ThoughtThread]
    @State private var showingCapture = false
    @State private var selectedFilter = ThreadFilter.all

    enum ThreadFilter {
        case all, starred
    }

    private var filteredThreads: [ThoughtThread] {
        switch selectedFilter {
        case .all: threads
        case .starred: threads.filter(\.isStarred)
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    filterChips
                        .padding(.horizontal, 16)

                    if filteredThreads.isEmpty {
                        ContentUnavailableView(
                            "No Thoughts Yet",
                            systemImage: "bubble.left.and.text.bubble.right",
                            description: Text("Tap + to capture your first thought")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredThreads) { thread in
                                NavigationLink {
                                    ThreadDetailView(thread: thread)
                                } label: {
                                    ThreadCard(thread: thread)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        thread.isStarred.toggle()
                                    } label: {
                                        Label(
                                            thread.isStarred ? "Unstar" : "Star",
                                            systemImage: thread.isStarred ? "star.slash" : "star"
                                        )
                                    }
                                    Button("Delete", role: .destructive) {
                                        modelContext.delete(thread)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 80)
            }

            Button {
                showingCapture = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(width: 56, height: 56)
                    .background(.white, in: Circle())
                    .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
            }
            .padding(24)
        }
        .navigationTitle("Thoughts")
        .sheet(isPresented: $showingCapture) {
            CaptureView()
        }
    }

    private var filterChips: some View {
        HStack(spacing: 8) {
            FilterChip(
                title: "All",
                count: threads.count,
                isSelected: selectedFilter == .all
            ) { selectedFilter = .all }

            FilterChip(
                title: "Starred",
                count: threads.filter(\.isStarred).count,
                isSelected: selectedFilter == .starred
            ) { selectedFilter = .starred }
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(title) (\(count))")
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.accentColor : Color(.systemGray5),
                    in: Capsule()
                )
                .foregroundStyle(isSelected ? .white : .secondary)
        }
    }
}

// MARK: - Thread Card

struct ThreadCard: View {
    let thread: ThoughtThread
    @Environment(\.appearanceConfig) private var config

    private var previewEntries: [ThreadEntry] {
        Array(thread.entries.sorted { $0.createdAt < $1.createdAt }.prefix(3))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EntryTimeline(entries: previewEntries) { entry in
                entryContent(entry)
            }

            HStack {
                Text(formattedTimestamp(thread.updatedAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if thread.isStarred {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                }
            }
            .padding(.top, 12)
        }
        .padding(config.containerPadding)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: config.containerCornerRadius))
    }

    @ViewBuilder
    private func entryContent(_ entry: ThreadEntry) -> some View {
        if let text = entry.text {
            Text(text)
                .font(.system(size: config.entryFontSize))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
        } else if !entry.photoFileNames.isEmpty {
            Label(
                "\(entry.photoFileNames.count) photo\(entry.photoFileNames.count == 1 ? "" : "s")",
                systemImage: "photo"
            )
            .foregroundStyle(.secondary)
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
