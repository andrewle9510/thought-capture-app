import Foundation
import SwiftData

@Model
final class ThoughtThread {
    var createdAt: Date
    var updatedAt: Date
    var isStarred: Bool
    @Relationship(deleteRule: .cascade, inverse: \ThreadEntry.thread)
    var entries: [ThreadEntry]

    init() {
        let now = Date()
        self.createdAt = now
        self.updatedAt = now
        self.isStarred = false
        self.entries = []
    }
}
