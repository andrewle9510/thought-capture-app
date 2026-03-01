import SwiftUI

@Observable
final class AppearanceConfig {
    // MARK: - Typography
    var entryFontSize: CGFloat = 16
    var timestampFontSize: CGFloat = 12

    // MARK: - Spacing
    var entrySpacing: CGFloat = 12
    var paragraphSpacing: CGFloat = 8

    // MARK: - Timeline
    var bulletSize: CGFloat = 8
    var connectorWidth: CGFloat = 1.5
    var bulletContentSpacing: CGFloat = 14

    // MARK: - Container (ThreadListView cards)
    var containerCornerRadius: CGFloat = 16
    var containerPadding: CGFloat = 16
}

extension EnvironmentValues {
    @Entry var appearanceConfig = AppearanceConfig()
}
