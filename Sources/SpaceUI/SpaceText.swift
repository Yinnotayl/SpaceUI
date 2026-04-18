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

@discardableResult public func registerFont(named name: String = spaceFontName, withExtension ext: String = "ttf", showSuccess: Bool = false) -> Bool {
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

    public func fontSize(_ style: Font.TextStyle) -> Font {
        switch self {
        case .orbitron_medium: return .orbitron_medium(style)
        case .din_alternate:   return .din_alternate(style)
        }
    }

    public static func register(_ showSuccess: Bool = false) {
        registerFont(named: spaceFontName, withExtension: "ttf", showSuccess: showSuccess)
    }
}



public extension Font.TextStyle {
    /// Returns the dynamic-type point size for this text style on both iOS and macOS.
    var platformPointSize: CGFloat {
        #if canImport(UIKit)
        let uiStyle: UIFont.TextStyle
        switch self {
        case .largeTitle:  uiStyle = .largeTitle
        case .title:       uiStyle = .title1
        case .title2:      uiStyle = .title2
        case .title3:      uiStyle = .title3
        case .headline:    uiStyle = .headline
        case .subheadline: uiStyle = .subheadline
        case .body:        uiStyle = .body
        case .callout:     uiStyle = .callout
        case .footnote:    uiStyle = .footnote
        case .caption:     uiStyle = .caption1
        case .caption2:    uiStyle = .caption2
        @unknown default:  uiStyle = .body
        }
        return UIFont.preferredFont(forTextStyle: uiStyle).pointSize

        #elseif canImport(AppKit)
        let nsStyle: NSFont.TextStyle
        switch self {
        case .largeTitle:  nsStyle = .largeTitle
        case .title:       nsStyle = .title1
        case .title2:      nsStyle = .title2
        case .title3:      nsStyle = .title3
        case .headline:    nsStyle = .headline
        case .subheadline: nsStyle = .subheadline
        case .body:        nsStyle = .body
        case .callout:     nsStyle = .callout
        case .footnote:    nsStyle = .footnote
        case .caption:     nsStyle = .caption1
        case .caption2:    nsStyle = .caption2
        @unknown default:  nsStyle = .body
        }
        return NSFont.preferredFont(forTextStyle: nsStyle, options: [:]).pointSize
        #endif
    }
}



public extension Font {
    static func orbitron_medium(_ textStyle: TextStyle = .body) -> Font {
        .custom("Orbitron-Medium", size: textStyle.platformPointSize, relativeTo: textStyle)
    }

    static func din_alternate(_ textStyle: TextStyle = .body) -> Font {
        .custom("DIN Alternate", size: textStyle.platformPointSize, relativeTo: textStyle)
    }
}



public struct SpaceText: View {
    var text: String
    var font: SpaceFont
    var size: Font.TextStyle

    public init(_ text: String, font: SpaceFont = .orbitron_medium, size: Font.TextStyle = .body) {
        self.text = text
        self.font = font
        self.size = size
    }

    public var body: some View {
        Text(text)
            .font(font.fontSize(size))
            .foregroundStyle(.white)
    }
}

public struct SpaceTitle: View {
    var text: String
    var font: SpaceFont = .orbitron_medium

    public init(_ text: String) { self.text = text }
    public init(_ text: String, font: SpaceFont) { self.text = text; self.font = font }

    public var body: some View { Text(text).spaceTitle(font) }
}

public struct SpaceTitle2: View {
    var text: String
    var font: SpaceFont = .orbitron_medium

    public init(_ text: String) { self.text = text }
    public init(_ text: String, font: SpaceFont) { self.text = text; self.font = font }

    public var body: some View { Text(text).spaceTitle2(font) }
}

public struct SpaceSubtitle: View {
    var text: String
    var font: SpaceFont = .din_alternate

    public init(_ text: String) { self.text = text }
    public init(_ text: String, font: SpaceFont) { self.text = text; self.font = font }

    public var body: some View { Text(text).spaceSubtitle(font) }
}



public extension View {
    func spaceTitle(_ font: SpaceFont = .orbitron_medium) -> some View {
        self
            .font(font == .orbitron_medium ? .orbitron_medium(.largeTitle) : .din_alternate(.largeTitle))
            .foregroundStyle(.white)
    }

    func spaceTitle2(_ font: SpaceFont = .orbitron_medium) -> some View {
        self
            .font(font == .orbitron_medium ? .orbitron_medium(.title) : .din_alternate(.title))
            .foregroundStyle(.white)
    }

    func spaceSubtitle(_ font: SpaceFont = .din_alternate) -> some View {
        self
            .font(font == .orbitron_medium ? .orbitron_medium(.body) : .din_alternate(.body))
            .foregroundStyle(font == .orbitron_medium ? .white : .white.opacity(0.6))
            .tracking(2)
    }
}
