import Foundation
import SwiftData

@Model
final class ThoughtThread {
    var createdAt: Date
    var updatedAt: Date
    var isStarred: Bool
    @Relationship(deleteRule: .cascade, inverse: \ThreadEntry.thread)
    var entries: [ThreadEntry]

    var previewText: String {
        let sorted = entries.sorted { $0.createdAt < $1.createdAt }
        if let text = sorted.first(where: { $0.text != nil })?.text {
            return text
        }
        if sorted.contains(where: { !$0.photoFileNames.isEmpty }) {
            return "📷 Photo"
        }
        return "Empty thread"
    }

    init() {
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
        self.isStarred = false
        self.entries = []
    }
}
