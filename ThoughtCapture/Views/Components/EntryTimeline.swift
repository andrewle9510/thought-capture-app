import SwiftUI

struct EntryTimeline<Content: View>: View {
    let entries: [ThreadEntry]
    @ViewBuilder let content: (ThreadEntry) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                let isLast = index == entries.count - 1

                HStack(alignment: .top, spacing: 14) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Color(.systemGray2))
                            .frame(width: 8, height: 8)

                        if !isLast {
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: 1.5)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(width: 8)
                    .padding(.top, 6)

                    content(entry)
                }
                .padding(.bottom, isLast ? 0 : 4)
            }
        }
    }
}
