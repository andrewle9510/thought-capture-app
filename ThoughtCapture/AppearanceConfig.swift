import SwiftUI

@Observable
final class AppearanceConfig {
    // MARK: - Typography
    var entryFontSize: CGFloat = 15
    var editingEntryFontSize: CGFloat = 15
    var timestampFontSize: CGFloat = 12

    // MARK: - Spacing
    var entrySpacing: CGFloat = 15
    var paragraphSpacing: CGFloat = 8

    // MARK: - Timeline
    var bulletSize: CGFloat = 10
    var connectorWidth: CGFloat = 1.5
    var bulletContentSpacing: CGFloat = 14

    // MARK: - Detail View
    var detailTopSpacing: CGFloat = 15

    // MARK: - Container
    var showListContainer: Bool = true
    var showDetailContainer: Bool = true
    var containerCornerRadius: CGFloat = 16
    var containerPadding: CGFloat = 16

    // MARK: - Capture View
    var captureHorizontalPadding: CGFloat = 8
    var captureCornerRadius: CGFloat = 16
    var captureTextHorizontalPadding: CGFloat = 16
    var captureTextTopPadding: CGFloat = 12
    var captureTextBottomPadding: CGFloat = 4
    var captureToolbarHorizontalPadding: CGFloat = 16
    var captureToolbarVerticalPadding: CGFloat = 10
    var captureToolbarSpacing: CGFloat = 20
    var captureBottomPadding: CGFloat = 4
    var captureSendButtonSize: CGFloat = 28
    var captureMicButtonSize: CGFloat = 28
}

extension EnvironmentValues {
    @Entry var appearanceConfig = AppearanceConfig()
}
