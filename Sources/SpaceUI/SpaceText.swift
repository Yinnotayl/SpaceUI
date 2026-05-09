import SwiftUI
import CoreText

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// SpaceText.swift
// Contains custom Text View structs along with Text View modifiers

public let spaceFontName: String = "Orbitron-Medium"

@discardableResult public func registerFont(
    named name: String = spaceFontName,
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
    case orbitron_medium
    case din_alternate

    public static func register(_ showSuccess: Bool = false) {
        registerFont(named: spaceFontName, withExtension: "ttf", showSuccess: showSuccess)
    }

    func resolve(for textStyle: Font.TextStyle) -> Font {
        switch self {
        case .orbitron_medium: return .orbitron_medium(textStyle)
        case .din_alternate:   return .din_alternate(textStyle)
        }
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
        #endif
    }
}

public extension Font {
    static func orbitron_medium(_ style: TextStyle = .body) -> Font {
        .custom("Orbitron-Medium", size: style.platformPointSize, relativeTo: style)
    }
    static func orbitron_medium(_ size: CGFloat) -> Font {
        .custom("Orbitron-Medium", size: size)
    }
    static func din_alternate(_ style: TextStyle = .body) -> Font {
        .custom("DIN Alternate", size: style.platformPointSize, relativeTo: style)
    }
    static func din_alternate(_ size: CGFloat) -> Font {
        .custom("DIN Alternate", size: size)
    }
}

public enum SpaceTextStyle {
    case title      // largeTitle, orbitron default
    case title2     // title, orbitron default
    case subtitle   // body, din_alternate default, tracking 2
    case body       // body, din_alternate default
    case caption    // caption, din_alternate default

    var defaultFont: SpaceFont {
        switch self {
        case .title, .title2:          return .orbitron_medium
        case .subtitle, .body, .caption: return .din_alternate
        }
    }

    var textStyle: Font.TextStyle {
        switch self {
        case .title:    return .largeTitle
        case .title2:   return .title
        case .subtitle: return .body
        case .body:     return .body
        case .caption:  return .caption
        }
    }

    var tracking: CGFloat {
        switch self {
        case .subtitle: return 2
        default:        return 0
        }
    }
    
    var defaultColor: Color {
        switch self.defaultFont {
        case .orbitron_medium: return .white
        case .din_alternate: return .gray
        }
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
        let resolvedFont = resolvedFontType.resolve(for: style.textStyle)

        let resolvedColor: Color = {
            if let color {
                return color
            }
            
            if let fontOverride {
                switch fontOverride {
                case .orbitron_medium: return .white
                case .din_alternate:   return .gray
                }
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
        font fontOverride: SpaceFont = .orbitron_medium,
        color: Color? = nil
    ) -> some View {
        let resolvedFont: Font = {
            switch fontOverride {
            case .orbitron_medium:
                return .orbitron_medium(size)

            case .din_alternate:
                return .din_alternate(size)
            }
        }()

        let resolvedColor: Color = {
            if let color {
                return color
            }

            switch fontOverride {
            case .orbitron_medium:
                return .white

            case .din_alternate:
                return .gray
            }
        }()

        self
            .font(resolvedFont)
            .foregroundStyle(resolvedColor)
    }
}

public extension View {
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
