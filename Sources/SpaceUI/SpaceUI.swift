import SwiftUI
import UIKit
import CoreText

// SpaceUI.swift
// Contains custom space-styled UI elements

public enum SpaceUIRole {
    case confirm
    case normal
    case destructive
}
public struct SpaceButton<L: View>: View {
    let label: () -> L
    let action: @MainActor () -> Void
    
    var role: SpaceUIRole = .normal
    var highlighted: Bool = false
    
    @State private var isPressed = false
    
    public init(
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: @escaping () -> L
    ) {
        self.label = label
        self.action = action
        self.role = role
        self.highlighted = highlighted
    }
    
    init(
        _ title: String,
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: @escaping @MainActor () -> Void
    ) where L == Text {
        self.init(role: role, highlighted: highlighted, action: action) {
            Text(title)
        }
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            SpaceCard(highlighted: highlighted, role: role) {
                label()
                    .spaceSubtitle(.orbitron_medium)
            }
            .spaceTitle2()
            .scaleEffect(isPressed ? 0.98 : (highlighted ? 1.03 : 1.0))
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.bouncy, value: highlighted)
    }
}
public struct SpaceToggle<L: View>: View {
    @Binding var isOn: Bool
    
    let label: () -> L
    var role: SpaceUIRole = .normal
    var highlightOverride: Bool? = nil
    
    public init(
        isOn: Binding<Bool>,
        role: SpaceUIRole = .normal,
        highlighted: Bool? = nil,
        @ViewBuilder label: @escaping () -> L
    ) {
        self._isOn = isOn
        self.label = label
        self.role = role
        self.highlightOverride = highlighted
    }
    
    public init(
        _ title: String,
        isOn: Binding<Bool>,
        role: SpaceUIRole = .normal,
        highlighted: Bool? = nil
    ) where L == Text {
        self.init(isOn: isOn, role: role, highlighted: highlighted) {
            Text(title)
        }
    }
    
    public var body: some View {
        SpaceButton(
            role: role,
            highlighted: highlightOverride ?? isOn
        ) {
            isOn.toggle()
        } label: {
            label()
        }
    }
}
public struct SpaceButtonTwoStep<L: View>: View {
    let label: () -> L
    
    let action: @MainActor () -> Void
    let confirmAction: @MainActor () -> Void
    
    var role: SpaceUIRole = .normal
    
    @State private var isArmed = false
    
    public init(
        role: SpaceUIRole = .normal,
        action: @escaping @MainActor () -> Void,
        confirmAction: @escaping @MainActor () -> Void = {},
        @ViewBuilder label: @escaping () -> L
    ) {
        self.label = label
        self.action = action
        self.confirmAction = confirmAction
        self.role = role
    }
    
    public init(
        _ title: String,
        role: SpaceUIRole = .normal,
        action: @escaping @MainActor () -> Void,
        confirmAction: @escaping @MainActor () -> Void = {}
    ) where L == Text {
        self.init(role: role, action: action, confirmAction: confirmAction) {
            Text(title)
        }
    }
    
    public var body: some View {
        SpaceButton(
            role: role,
            highlighted: isArmed
        ) {
            if isArmed {
                isArmed = false
                action()
            } else {
                isArmed = true
                confirmAction()
            }
        } label: {
            label()
        }
    }
}

public struct SpaceTextField: View {
    var titleKey: String? = nil
    var placeholder: String = ""
    @Binding var text: String
    var role: SpaceUIRole = .normal
    var highlighted: Bool? = nil
    
    public init(_ titleKey: String, text: Binding<String>, placeholder: String = "") {
        self._text = text
        self.titleKey = titleKey
        self.placeholder = placeholder
    }
    public init(text: Binding<String>, placeholder: String = "") {
        self._text = text
        self.titleKey = nil
        self.placeholder = placeholder
    }
    public init(_ titleKey: String, text: Binding<String>, placeholder: String = "", role: SpaceUIRole = .normal, highlighted: Bool? = nil) {
        self._text = text
        self.titleKey = titleKey
        self.placeholder = placeholder
        self.highlighted = highlighted
        self.role = role
    }
    public init(text: Binding<String>, placeholder: String = "", role: SpaceUIRole = .normal, highlighted: Bool? = nil) {
        self._text = text
        self.titleKey = nil
        self.placeholder = placeholder
        self.highlighted = highlighted
        self.role = role
    }
    
    public var body: some View {
        SpaceCard(highlighted: highlighted ?? false, role: role) {
            VStack(alignment: .leading) {
                if let titleKey {
                    Text(titleKey)
                        .spaceSubtitle(.orbitron_medium)
                }
                TextField(placeholder, text: $text)
                    .spaceSubtitle()
            }
        }
        .frame(idealWidth: 300)
        .fixedSize()
    }
}

public struct SpaceCard<Content: View>: View {
    @State private var rotation: Double = 0
    
    let content: Content
    var highlighted: Bool = false
    var role: SpaceUIRole
    
    public init(highlighted: Bool = false, role: SpaceUIRole = .normal, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.highlighted = highlighted
        self.role = role
    }
    public init(title: String, subtitle: String, role: SpaceUIRole = .normal, highlighted: Bool = false) where Content == VStack<TupleView<(AnyView, AnyView)>> {
        self.content = VStack(alignment: .leading) {
            AnyView(Text(title).spaceTitle())
            AnyView(Text(subtitle).spaceSubtitle())
        }
        self.highlighted = highlighted
        self.role = role
    }
    
    var gradientColours: [Color] {
        switch role {
        case .confirm:
            return [.mint, .indigo]
        case .normal:
            return [.teal, .cyan]
        case .destructive:
            return [.red, .pink]
        }
    }
    var highlightColour: AngularGradient {
        let colors: [Color] = [gradientColours[0], gradientColours[1], gradientColours[1], gradientColours[0]]
        
        return AngularGradient(
            colors: colors,
            center: .center,
            angle: .degrees(rotation)
        )
    }
    
    var shadowColor: Color {
        switch role {
        case .confirm: return .blue
        case .normal: return .cyan
        case .destructive: return .red
        }
    }
    
    public var body: some View {
        VStack {
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    highlighted ? highlightColour.opacity(1) : highlightColour.opacity(0.7),
                    lineWidth: highlighted ? 2 : 1
                )
        )
        .shadow(color: highlighted ? shadowColor.opacity(0.8) : .clear, radius: 25)
        .animation(.bouncy, value: highlighted)
        .onAppear {
            guard highlighted else { return }
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .onChange(of: highlighted) { _, isOn in
            if isOn {
                rotation = 0
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        }
    }
}
