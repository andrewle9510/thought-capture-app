import Foundation

extension Date {
    var relativeTimestamp: String {
        if Calendar.current.isDateInToday(self) {
            return formatted(.dateTime.hour().minute())
        } else {
            return formatted(.dateTime.month(.abbreviated).day())
        }
    }
}
