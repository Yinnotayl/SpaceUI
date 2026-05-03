import SwiftUI

// SpaceUI.swift
// Contains custom space-styled UI elements

public enum SpaceUIRole {
    case confirm
    case normal
    case destructive
    
    var color: Color {
        switch self {
        case .confirm: return .blue
        case .normal: return .cyan
        case .destructive: return .red
        }
    }
    
    var gradientColour: [Color] {
        switch self {
        case .confirm:
            return [.mint, .indigo]
        case .normal:
            return [.teal, .cyan]
        case .destructive:
            return [.red, .pink]
        }
    }
    
    func linearGradient(startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: self.gradientColour),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    func angularGradient(angle: Angle) -> AngularGradient {
        let colors: [Color] = [self.gradientColour[0], self.gradientColour[1], self.gradientColour[1], self.gradientColour[0]]
        return AngularGradient(
            colors: colors,
            center: .center,
            angle: angle
        )
    }
}

// MARK: - Press Style (scroll-safe)

private struct SpacePressStyle: ButtonStyle {
    var highlighted: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : (highlighted ? 1.03 : 1.0))
            .animation(.bouncy, value: configuration.isPressed)
    }
}

// MARK: - SpaceButton

public struct SpaceButton<L: View>: View {
    let label: () -> L
    let action: @MainActor () -> Void
    
    var role: SpaceUIRole = .normal
    var highlighted: Bool = false
    
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
    
    public init(
        _ title: String,
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: @escaping @MainActor () -> Void
    ) where L == Text {
        self.init(role: role, highlighted: highlighted, action: action) {
            Text(title)
        }
    }
    
    public init(
        title: String,
        subtitle: String,
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: @escaping @MainActor () -> Void
    ) where L == VStack<TupleView<(AnyView, AnyView)>> {
        self.label = {
            VStack(alignment: .leading) {
                AnyView(Text(title).spaceTitle())
                AnyView(Text(subtitle).spaceSubtitle())
            }
        }
        self.highlighted = highlighted
        self.role = role
        self.action = action
    }
    
    public init(
        title2: String,
        subtitle: String,
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: @escaping @MainActor () -> Void
    ) where L == VStack<TupleView<(AnyView, AnyView)>> {
        self.label = {
            VStack(alignment: .leading) {
                AnyView(Text(title2).spaceTitle2())
                AnyView(Text(subtitle).spaceSubtitle())
            }
        }
        self.highlighted = highlighted
        self.role = role
        self.action = action
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
        }
        .buttonStyle(SpacePressStyle(highlighted: highlighted))
        .spaceHoverEffect()
        .animation(.bouncy, value: highlighted)
    }
}

// MARK: - SpaceToggle

public struct SpaceToggle<L: View>: View {
    @Binding public var isOn: Bool
    
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

// MARK: - SpaceButtonTwoStep

public struct SpaceButtonTwoStep<L: View, Trigger: Equatable>: View {
    let label: () -> L
    
    let action: @MainActor () -> Void
    let confirmAction: @MainActor () -> Void
    
    var role: SpaceUIRole = .normal
    var disarmTrigger: Trigger
    
    @State private var isArmed: Bool = false
    
    public init(
        role: SpaceUIRole = .normal,
        action: @escaping @MainActor () -> Void,
        confirmAction: @escaping @MainActor () -> Void = {},
        disarmTrigger: Trigger = false,
        @ViewBuilder label: @escaping () -> L
    ) where Trigger == Bool {
        self.label = label
        self.action = action
        self.confirmAction = confirmAction
        self.role = role
        self.disarmTrigger = disarmTrigger
    }
    
    public init(
        role: SpaceUIRole = .normal,
        action: @escaping @MainActor () -> Void,
        confirmAction: @escaping @MainActor () -> Void = {},
        disarmTrigger: Trigger,
        @ViewBuilder label: @escaping () -> L
    ) {
        self.label = label
        self.action = action
        self.confirmAction = confirmAction
        self.role = role
        self.disarmTrigger = disarmTrigger
    }
    
    public init(
        _ title: String,
        role: SpaceUIRole = .normal,
        disarmTrigger: Trigger = false,
        action: @escaping @MainActor () -> Void,
        confirmAction: @escaping @MainActor () -> Void = {}
    ) where L == Text, Trigger == Bool {
        self.init(role: role, action: action, confirmAction: confirmAction, disarmTrigger: disarmTrigger) {
            Text(title)
        }
    }
    
    public init(
        _ title: String,
        role: SpaceUIRole = .normal,
        disarmTrigger: Trigger,
        action: @escaping @MainActor () -> Void,
        confirmAction: @escaping @MainActor () -> Void = {}
    ) where L == Text {
        self.init(role: role, action: action, confirmAction: confirmAction, disarmTrigger: disarmTrigger) {
            Text(title)
        }
    }
    
    public var body: some View {
        SpaceButton(role: role, highlighted: isArmed) {
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
        .onChange(of: disarmTrigger) {
            isArmed = false
        }
    }
}

// MARK: - SpaceTextField

public struct SpaceTextField: View {
    var titleKey: String? = nil
    var placeholder: String = ""
    @Binding public var text: String
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
                TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundStyle(.gray))
                    .textFieldStyle(.plain)
                    .spaceSubtitle()
            }
        }
    }
}

// MARK: - SpacePanel

public struct SpacePanel<Content: View>: View {
    var content: Content
    var role: SpaceUIRole = .normal
    private var customColor: Color?

    var color: Color {
        customColor ?? role.color
    }

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.role = .normal
        self.customColor = nil
    }
    
    public init(role: SpaceUIRole, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.role = role
        self.customColor = nil
    }
    
    public init(color: Color, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.role = .normal
        self.customColor = color
    }

    public var body: some View {
        VStack {
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.black.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color, lineWidth: 1)
                )
        )
    }
}

// MARK: - SpaceCard

public struct SpaceCard<Content: View>: View {
    @State private var rotation: Double = 0
    
    let duration: CGFloat = 4.5
    
    var content: Content
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
    
    public init(title2: String, subtitle: String, role: SpaceUIRole = .normal, highlighted: Bool = false) where Content == VStack<TupleView<(AnyView, AnyView)>> {
        self.content = VStack(alignment: .leading) {
            AnyView(Text(title2).spaceTitle2())
            AnyView(Text(subtitle).spaceSubtitle())
        }
        self.highlighted = highlighted
        self.role = role
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
                    highlighted
                        ? role.angularGradient(angle: .degrees(rotation)).opacity(1)
                        : role.angularGradient(angle: .degrees(rotation)).opacity(0.7),
                    lineWidth: highlighted ? 2 : 1
                )
        )
        .shadow(color: highlighted ? role.color.opacity(0.8) : .clear, radius: 25)
        .animation(.bouncy, value: highlighted)
        .onAppear {
            guard highlighted else { return }
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .onChange(of: highlighted) { _, isOn in
            if isOn {
                rotation = 0
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        }
    }
}

// MARK: - SpaceListRow

public struct SpaceListRow<Content: View>: View {
    private var content: Content
    private var role: SpaceUIRole
    private var highlighted: Bool
    private var action: (@MainActor () -> Void)?

    // Generic content init
    public init(
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: (@MainActor () -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.role = role
        self.highlighted = highlighted
        self.action = action
    }

    // Single string
    public init(
        _ text: String,
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: (@MainActor () -> Void)? = nil
    ) where Content == HStack<TupleView<(AnyView, Spacer)>> {
        self.content = HStack {
            AnyView(Text(text).spaceSubtitle())
            Spacer()
        }
        self.role = role
        self.highlighted = highlighted
        self.action = action
    }

    // Title + subtitle strings
    public init(
        title: String,
        subtitle: String,
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: (@MainActor () -> Void)? = nil
    ) where Content == HStack<TupleView<(AnyView, Spacer, AnyView)>> {
        self.content = HStack {
            AnyView(Text(title).spaceSubtitle(.orbitron_medium))
            Spacer()
            AnyView(Text(subtitle).spaceSubtitle())
        }
        self.role = role
        self.highlighted = highlighted
        self.action = action
    }

    // Title + subtitle views
    public init(
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: (@MainActor () -> Void)? = nil,
        title: some View,
        subtitle: some View
    ) where Content == HStack<TupleView<(AnyView, Spacer, AnyView)>> {
        self.content = HStack {
            AnyView(title)
            Spacer()
            AnyView(subtitle)
        }
        self.role = role
        self.highlighted = highlighted
        self.action = action
    }

    // Title + subtitle view builders
    public init(
        role: SpaceUIRole = .normal,
        highlighted: Bool = false,
        action: (@MainActor () -> Void)? = nil,
        @ViewBuilder title: () -> some View,
        @ViewBuilder subtitle: () -> some View
    ) where Content == HStack<TupleView<(AnyView, Spacer, AnyView)>> {
        self.content = HStack {
            AnyView(title())
            Spacer()
            AnyView(subtitle())
        }
        self.role = role
        self.highlighted = highlighted
        self.action = action
    }

    public var body: some View {
        let card = SpaceCard(highlighted: highlighted, role: role) {
            HStack { content }
        }

        if let action {
            Button(action: action) { card }
                .buttonStyle(SpacePressStyle(highlighted: highlighted))
                .spaceHoverEffect()
        } else {
            card
        }
    }
}

// MARK: - SpaceSegmentedProgressView

public struct SpaceSegmentedProgressView: View {
    private var fraction: CGFloat
    private var fillColor: Color = .cyan
    private var segments: Int = 20

    public init(_ fraction: CGFloat) {
        self.fraction = min(max(fraction, 0), 1)
    }
    
    public init(_ fraction: CGFloat, segments: Int = 20, fillColor: Color = .cyan) {
        self.fraction = min(max(fraction, 0), 1)
        self.segments = max(segments, 1)
        self.fillColor = fillColor
    }

    public var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<segments, id: \.self) { i in
                let threshold = CGFloat(i + 1) / CGFloat(segments)
                RoundedRectangle(cornerRadius: 2)
                    .fill(threshold <= fraction ? fillColor : Color.white.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: 10)
                    .contentTransition(.interpolate)
            }
        }
    }
}

// MARK: - Preview

struct SpaceUIPreview: View {
    init() { SpaceFont.register() }
    
    @State private var isOn: Bool = false
    @State private var text: String = ""
    @State private var counter: CGFloat = 0
    
    var body: some View {
        SpaceContainer(spacing: 20) {
            SpaceContainer(spacing: 6) {
                Text("SpaceUI").spaceTextStyle(.title)
                Text("Simple SpaceUI showcase").spaceTextStyle(.subtitle)
            }
            SpaceCard(title: "Space UI", subtitle: "Space UI is a custom UI style that feels sci-fi", role: .confirm, highlighted: true)
            SpaceToggle("Space Toggle Button", isOn: $isOn)
            SpaceButton("increment") {
                counter += 0.05
            }
            SpaceButtonTwoStep("Two step", disarmTrigger: isOn) {
                print("action activated")
            }
            SpaceTextField("Space Text Field", text: $text, placeholder: "Type text here")
            SpaceSection("Space Section") {
                SpaceListRow(title: "Space row Title", subtitle: "subtitle")
                SpaceListRow(title: "Tappable row", subtitle: "JOIN", role: .confirm, highlighted: true) {
                    print("tapped")
                }
                SpaceListRow(
                    title: Text("server1").spaceTextStyle(.subtitle, font: .orbitron_medium),
                    subtitle: Text("JOIN").spaceTextStyle(.subtitle, color: .cyan)
                )
                SpaceListRow {
                    SpaceSegmentedProgressView(counter, segments: 5)
                        .animation(.easeOut(duration: 0.2), value: counter)
                }
            }
            SpacePanel {
                SpaceTitle("this is a panel")
            }
        }
        .spaceLayoutScrollable()
        .spaceBackground()
    }
}

#Preview("SpaceUI Preview") {
    SpaceUIPreview()
}
#Preview("SpaceUI 2") {
    VStack {
        SpaceText("hello")
    }
    .spaceBackground()
}
