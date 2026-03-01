import SwiftUI

struct EntryTimeline<Content: View>: View {
    let entries: [ThreadEntry]
    @ViewBuilder let content: (ThreadEntry) -> Content
    @Environment(\.appearanceConfig) private var config

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                let isLast = index == entries.count - 1

                HStack(alignment: .top, spacing: config.bulletContentSpacing) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Color(.systemGray2))
                            .frame(width: config.bulletSize, height: config.bulletSize)

                        if !isLast {
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: config.connectorWidth)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(width: config.bulletSize)
                    .padding(.top, 6)

                    content(entry)
                }
                .padding(.bottom, isLast ? 0 : config.entrySpacing)
            }
        }
    }
}
