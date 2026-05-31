import SwiftUI
import CoreText

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public let spaceFontNames = [
    "Orbitron-Regular",
    "Orbitron-Medium",
    "Orbitron-SemiBold",
    "Orbitron-Bold",
    "Orbitron-ExtraBold",
    "Orbitron-Black",
    "SpaceGrotesk-Light",
    "SpaceGrotesk-Regular",
    "SpaceGrotesk-Medium",
    "SpaceGrotesk-SemiBold",
    "SpaceGrotesk-Bold"
]

@discardableResult public func registerFont(
    named name: String,
    withExtension ext: String = "ttf",
    showSuccess: Bool = false
) -> Bool {
    guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
        print("Font not found: \(name).\(ext)")
        return false
    }

    var error: Unmanaged<CFError>?
    let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
    if let error = error?.takeUnretainedValue() {
        print("Font registration error: \(error)")
    } else if showSuccess {
        print("Font \"\(name)\" registered successfully")
    }
    return success
}

public enum SpaceFont {
    case orbitronRegular
    case orbitronMedium
    case orbitronSemiBold
    case orbitronBold
    case orbitronExtraBold
    case orbitronBlack
    case spaceGroteskLight
    case spaceGroteskRegular
    case spaceGroteskMedium
    case spaceGroteskSemiBold
    case spaceGroteskBold

    case orbitron_medium

    @available(*, deprecated, message: "DIN Alternate is no longer a SpaceUI default. Use Space Grotesk instead.")
    case din_alternate

    public static func register(_ showSuccess: Bool = false) {
        [
            "Orbitron-Regular",
            "Orbitron-Medium",
            "Orbitron-SemiBold",
            "Orbitron-Bold",
            "Orbitron-ExtraBold",
            "Orbitron-Black",
            "SpaceGrotesk-Light",
            "SpaceGrotesk-Regular",
            "SpaceGrotesk-Medium",
            "SpaceGrotesk-SemiBold",
            "SpaceGrotesk-Bold"
        ].forEach { registerFont(named: $0, withExtension: "ttf", showSuccess: showSuccess) }
    }

    var fontName: String {
        switch self {
        case .orbitronRegular:
            return "Orbitron-Regular"
        case .orbitronMedium, .orbitron_medium:
            return "Orbitron-Medium"
        case .orbitronSemiBold:
            return "Orbitron-SemiBold"
        case .orbitronBold:
            return "Orbitron-Bold"
        case .orbitronExtraBold:
            return "Orbitron-ExtraBold"
        case .orbitronBlack:
            return "Orbitron-Black"
        case .spaceGroteskLight:
            return "SpaceGrotesk-Light"
        case .spaceGroteskRegular, .din_alternate:
            return "SpaceGrotesk-Regular"
        case .spaceGroteskMedium:
            return "SpaceGrotesk-Medium"
        case .spaceGroteskSemiBold:
            return "SpaceGrotesk-SemiBold"
        case .spaceGroteskBold:
            return "SpaceGrotesk-Bold"
        }
    }

    var prefersBrightForeground: Bool {
        switch self {
        case .orbitronRegular, .orbitronMedium, .orbitronSemiBold, .orbitronBold,
             .orbitronExtraBold, .orbitronBlack, .orbitron_medium:
            return true
        case .spaceGroteskLight, .spaceGroteskRegular, .spaceGroteskMedium,
             .spaceGroteskSemiBold, .spaceGroteskBold, .din_alternate:
            return false
        }
    }

    func resolve(for textStyle: Font.TextStyle) -> Font {
        .custom(fontName, size: textStyle.platformPointSize, relativeTo: textStyle)
    }

    func resolve(size: CGFloat) -> Font {
        .custom(fontName, size: size)
    }
}

public extension Font.TextStyle {
    var platformPointSize: CGFloat {
        #if canImport(UIKit)
        let map: [Font.TextStyle: UIFont.TextStyle] = [
            .largeTitle: .largeTitle, .title: .title1, .title2: .title2,
            .title3: .title3, .headline: .headline, .subheadline: .subheadline,
            .body: .body, .callout: .callout, .footnote: .footnote,
            .caption: .caption1, .caption2: .caption2
        ]
        return UIFont.preferredFont(forTextStyle: map[self] ?? .body).pointSize
        #elseif canImport(AppKit)
        let map: [Font.TextStyle: NSFont.TextStyle] = [
            .largeTitle: .largeTitle, .title: .title1, .title2: .title2,
            .title3: .title3, .headline: .headline, .subheadline: .subheadline,
            .body: .body, .callout: .callout, .footnote: .footnote,
            .caption: .caption1, .caption2: .caption2
        ]
        return NSFont.preferredFont(forTextStyle: map[self] ?? .body, options: [:]).pointSize
        #else
        switch self {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .subheadline: return 15
        case .callout: return 16
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        default: return 17
        }
        #endif
    }
}

public extension Font {
    static func orbitronRegular(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronRegular.resolve(for: style)
    }

    static func orbitronRegular(_ size: CGFloat) -> Font {
        SpaceFont.orbitronRegular.resolve(size: size)
    }

    static func orbitronMedium(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronMedium.resolve(for: style)
    }

    static func orbitronMedium(_ size: CGFloat) -> Font {
        SpaceFont.orbitronMedium.resolve(size: size)
    }

    static func orbitronSemiBold(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronSemiBold.resolve(for: style)
    }

    static func orbitronSemiBold(_ size: CGFloat) -> Font {
        SpaceFont.orbitronSemiBold.resolve(size: size)
    }

    static func orbitronBold(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronBold.resolve(for: style)
    }

    static func orbitronBold(_ size: CGFloat) -> Font {
        SpaceFont.orbitronBold.resolve(size: size)
    }

    static func orbitronExtraBold(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronExtraBold.resolve(for: style)
    }

    static func orbitronExtraBold(_ size: CGFloat) -> Font {
        SpaceFont.orbitronExtraBold.resolve(size: size)
    }

    static func orbitronBlack(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronBlack.resolve(for: style)
    }

    static func orbitronBlack(_ size: CGFloat) -> Font {
        SpaceFont.orbitronBlack.resolve(size: size)
    }

    static func spaceGroteskLight(_ style: TextStyle = .body) -> Font {
        SpaceFont.spaceGroteskLight.resolve(for: style)
    }

    static func spaceGroteskLight(_ size: CGFloat) -> Font {
        SpaceFont.spaceGroteskLight.resolve(size: size)
    }

    static func spaceGroteskRegular(_ style: TextStyle = .body) -> Font {
        SpaceFont.spaceGroteskRegular.resolve(for: style)
    }

    static func spaceGroteskRegular(_ size: CGFloat) -> Font {
        SpaceFont.spaceGroteskRegular.resolve(size: size)
    }

    static func spaceGroteskMedium(_ style: TextStyle = .body) -> Font {
        SpaceFont.spaceGroteskMedium.resolve(for: style)
    }

    static func spaceGroteskMedium(_ size: CGFloat) -> Font {
        SpaceFont.spaceGroteskMedium.resolve(size: size)
    }

    static func spaceGroteskSemiBold(_ style: TextStyle = .body) -> Font {
        SpaceFont.spaceGroteskSemiBold.resolve(for: style)
    }

    static func spaceGroteskSemiBold(_ size: CGFloat) -> Font {
        SpaceFont.spaceGroteskSemiBold.resolve(size: size)
    }

    static func spaceGroteskBold(_ style: TextStyle = .body) -> Font {
        SpaceFont.spaceGroteskBold.resolve(for: style)
    }

    static func spaceGroteskBold(_ size: CGFloat) -> Font {
        SpaceFont.spaceGroteskBold.resolve(size: size)
    }

    static func orbitron_medium(_ style: TextStyle = .body) -> Font {
        SpaceFont.orbitronMedium.resolve(for: style)
    }

    static func orbitron_medium(_ size: CGFloat) -> Font {
        SpaceFont.orbitronMedium.resolve(size: size)
    }

    @available(*, deprecated, message: "DIN Alternate is no longer a SpaceUI default. Use Space Grotesk instead.")
    static func din_alternate(_ style: TextStyle = .body) -> Font {
        SpaceFont.spaceGroteskRegular.resolve(for: style)
    }

    @available(*, deprecated, message: "DIN Alternate is no longer a SpaceUI default. Use Space Grotesk instead.")
    static func din_alternate(_ size: CGFloat) -> Font {
        SpaceFont.spaceGroteskRegular.resolve(size: size)
    }
}

public enum SpaceTextStyle {
    case largeDisplay
    case display
    case display2
    case title
    case title2
    case subtitle
    case body
    case caption

    var defaultFont: SpaceFont {
        switch self {
        case .largeDisplay:
            return .orbitronBlack
        case .display:
            return .orbitronExtraBold
        case .display2:
            return .orbitronBold
        case .title:
            return .orbitronSemiBold
        case .title2:
            return .orbitronMedium
        case .subtitle:
            return .spaceGroteskMedium
        case .body, .caption:
            return .spaceGroteskRegular
        }
    }

    var textStyle: Font.TextStyle {
        switch self {
        case .largeDisplay, .display, .display2:
            return .largeTitle
        case .title:
            return .largeTitle
        case .title2:
            return .title
        case .subtitle, .body:
            return .body
        case .caption:
            return .caption
        }
    }

    var fixedSize: CGFloat? {
        switch self {
        case .largeDisplay:
            return 100
        case .display:
            return 72
        case .display2:
            return 55
        case .title, .title2, .subtitle, .body, .caption:
            return nil
        }
    }

    var tracking: CGFloat {
        0
    }

    var defaultColor: Color {
        defaultFont.prefersBrightForeground ? .white : .gray
    }
}

public extension View {
    @ViewBuilder
    func spaceTextStyle(
        _ style: SpaceTextStyle,
        font fontOverride: SpaceFont? = nil,
        color: Color? = nil
    ) -> some View {
        let resolvedFontType = fontOverride ?? style.defaultFont
        let resolvedFont = style.fixedSize.map { resolvedFontType.resolve(size: $0) }
            ?? resolvedFontType.resolve(for: style.textStyle)

        let resolvedColor: Color = {
            if let color {
                return color
            }

            if let fontOverride {
                return fontOverride.prefersBrightForeground ? .white : .gray
            }

            return style.defaultColor
        }()

        self
            .font(resolvedFont)
            .tracking(style.tracking)
            .foregroundStyle(resolvedColor)
    }

    @ViewBuilder
    func spaceTextStyle(
        _ size: CGFloat,
        font fontOverride: SpaceFont = .orbitronMedium,
        color: Color? = nil
    ) -> some View {
        self
            .font(fontOverride.resolve(size: size))
            .foregroundStyle(color ?? (fontOverride.prefersBrightForeground ? .white : .gray))
    }
}

public extension View {
    func spaceLargeDisplay(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.largeDisplay, font: font, color: color)
    }

    func spaceDisplay(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.display, font: font, color: color)
    }

    func spaceDisplay2(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.display2, font: font, color: color)
    }

    func spaceTitle(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.title, font: font, color: color)
    }

    func spaceTitle2(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.title2, font: font, color: color)
    }

    func spaceSubtitle(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.subtitle, font: font, color: color)
    }

    func spaceTextBody(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.body, font: font, color: color)
    }

    func spaceCaption(_ font: SpaceFont? = nil, color: Color? = nil) -> some View {
        spaceTextStyle(.caption, font: font, color: color)
    }
}

public struct SpaceText: View {
    var text: String
    var style: SpaceTextStyle
    var fontOverride: SpaceFont?
    var color: Color?

    public init(
        _ text: String,
        style: SpaceTextStyle = .body,
        font: SpaceFont? = nil,
        color: Color? = nil
    ) {
        self.text = text
        self.style = style
        self.fontOverride = font
        self.color = color
    }

    public var body: some View {
        Text(text)
            .spaceTextStyle(style, font: fontOverride, color: color)
    }
}

public struct SpaceLargeDisplay: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceLargeDisplay() }
}

public struct SpaceDisplay: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceDisplay() }
}

public struct SpaceDisplay2: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceDisplay2() }
}

public struct SpaceTitle: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceTitle() }
}

public struct SpaceTitle2: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceTitle2() }
}

public struct SpaceSubtitle: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceSubtitle() }
}

public struct SpaceCaption: View {
    var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).spaceCaption() }
}
