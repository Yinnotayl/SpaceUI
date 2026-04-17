import SwiftUI
import CoreText
import UIKit

// SpaceText.swift
// Contains custom Text Views along with custom font

public let spaceFontName: String = "Orbitron-Medium"

@discardableResult public func registerFont(named name: String = spaceFontName, withExtension ext: String = "ttf") -> Bool {
    guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
        print("Font not found: \(name).\(ext)")
        return false
    }
    
    var error: Unmanaged<CFError>?
    let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
    
    if let error = error?.takeUnretainedValue() {
        print("Font registration error: \(error)")
    }
    
    return success
}



public struct SpaceText: View {
    var text: String
    var font: SpaceFont
    var size: Font.TextStyle
    
    public init(
        _ text: String,
        font: SpaceFont = .orbitron_medium,
        size: Font.TextStyle = .body
    ) {
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
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ text: String, font: SpaceFont) {
        self.text = text
        self.font = font
    }
    
    public var body: some View {
        Text(text).spaceTitle(font)
    }
}

public struct SpaceTitle2: View {
    var text: String
    var font: SpaceFont = .orbitron_medium
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ text: String, font: SpaceFont) {
        self.text = text
        self.font = font
    }
    
    public var body: some View {
        Text(text).spaceTitle2(font)
    }
}

public struct SpaceSubtitle: View {
    var text: String
    var font: SpaceFont = .din_alternate
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ text: String, font: SpaceFont) {
        self.text = text
        self.font = font
    }
    
    public var body: some View {
        Text(text).spaceSubtitle(font)
    }
}

extension Font {
    static func orbitron_medium(_ textStyle: TextStyle = .body) -> Font {
        .custom("Orbitron-Medium", size: 16, relativeTo: textStyle)
    }
    
    static func din_alternate(_ textStyle: TextStyle = .body) -> Font {
        .custom("DIN Alternate", size: 16, relativeTo: textStyle)
    }
}


extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }
}


public enum SpaceFont {
    case orbitron_medium
    case din_alternate
    
    func fontSize(_ style: Font.TextStyle) -> Font {
        switch self {
        case .orbitron_medium:
            return .orbitron_medium(style)
        case .din_alternate:
            return .din_alternate(style)
        }
    }
    
    func register() {
        registerFont(named: spaceFontName, withExtension: "ttf")
    }
}


extension View {
    func spaceTitle(_ font: SpaceFont = .orbitron_medium) -> some View {
        self
            .font(
                font == .orbitron_medium
                ? .orbitron_medium(.largeTitle)
                : .din_alternate(.largeTitle)
            )
            .foregroundStyle(.white)
    }
    
    func spaceTitle2(_ font: SpaceFont = .orbitron_medium) -> some View {
        self
            .font(
                font == .orbitron_medium
                ? .orbitron_medium(.title)
                : .din_alternate(.title)
            )
            .foregroundStyle(.white)
    }
    
    func spaceSubtitle(_ font: SpaceFont = .din_alternate) -> some View {
        self
            .font(
                font == .orbitron_medium
                ? .orbitron_medium(.body)
                : .din_alternate(.body)
            )
            .foregroundStyle(
                font == .orbitron_medium ? .white : .white.opacity(0.6)
            )
            .tracking(2)
    }
}
