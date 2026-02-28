import Foundation
import SwiftData

@Model
final class ThreadEntry {
    var createdAt: Date
    var text: String?
    var photoFileNames: [String]
    var thread: ThoughtThread?

    init(text: String? = nil, photoFileNames: [String] = []) {
        self.createdAt = Date()
        self.text = text
        self.photoFileNames = photoFileNames
    }
}
