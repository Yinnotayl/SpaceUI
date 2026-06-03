import SwiftUI

// SpaceUI.swift
// Contains custom space-styled UI elements

public enum SpaceUIRole: Equatable {
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
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceButtonStyleOverride) private var buttonStyleOverride

    let label: () -> L
    let action: @MainActor () -> Void
    
    var role: SpaceUIRole?
    var highlighted: Bool?
    @State private var isPressed: Bool = false
    
    public init(
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
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
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        action: @escaping @MainActor () -> Void
    ) where L == Text {
        self.init(role: role, highlighted: highlighted, action: action) {
            Text(title)
        }
    }
    
    public init(
        title: String,
        subtitle: String,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
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
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
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
        let resolvedStyle = (buttonStyleOverride ?? inheritedStyle ?? .primary)
            .resolving(role: role, highlighted: highlighted)

        Button {
            action()
        } label: {
            SpaceCard {
                label().spaceSubtitle(.orbitronMedium)
            }
            .spaceCardStyle(resolvedStyle)
            .spaceTitle2()
            .scaleEffect(isPressed ? 0.98 : (resolvedStyle.highlighted ? 1.03 : 1.0))
        }
        .spaceHoverEffect()
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.bouncy, value: resolvedStyle.highlighted)
        .environment(\.spaceButtonStyleOverride, nil)
    }
}

// MARK: - SpaceToggle

public struct SpaceToggle<L: View>: View {
    @Binding public var isOn: Bool
    
    let label: () -> L
    var role: SpaceUIRole?
    var highlightOverride: Bool? = nil
    
    public init(
        isOn: Binding<Bool>,
        role: SpaceUIRole? = nil,
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
        role: SpaceUIRole? = nil,
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

// MARK: - SpaceChip

public struct SpaceChip: View {
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceChipStyleOverride) private var chipStyleOverride
    @Environment(\.spaceStyleTokens) private var tokens

    @Binding private var isOn: Bool

    private var onText: String
    private var offText: String
    private var onIcon: String?
    private var offIcon: String?
    private var textStyle: SpaceTextStyle
    private var font: SpaceFont

    public init(
        _ text: String,
        isOn: Binding<Bool>,
        icon: String? = nil,
        textStyle: SpaceTextStyle = .caption,
        font: SpaceFont = .spaceGroteskSemiBold
    ) {
        self._isOn = isOn
        self.onText = text
        self.offText = text
        self.onIcon = icon
        self.offIcon = icon
        self.textStyle = textStyle
        self.font = font
    }

    public init(
        isOn: Binding<Bool>,
        onText: String = "ON",
        offText: String = "OFF",
        onIcon: String? = "power.circle.fill",
        offIcon: String? = "power.circle",
        textStyle: SpaceTextStyle = .caption,
        font: SpaceFont = .spaceGroteskSemiBold
    ) {
        self._isOn = isOn
        self.onText = onText
        self.offText = offText
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.textStyle = textStyle
        self.font = font
    }

    public var body: some View {
        let baseStyle = chipStyleOverride ?? inheritedStyle ?? .glass
        let resolvedStyle = baseStyle.resolving(
            role: nil,
            highlighted: isOn || baseStyle.highlighted
        )

        Button {
            isOn.toggle()
        } label: {
            chipLabel
                .spaceTextStyle(textStyle, font: font, color: foregroundColor(for: resolvedStyle))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .contentTransition(.opacity)
                .modifier(
                    SpaceShapeSurfaceModifier(
                        shape: Capsule(),
                        style: resolvedStyle,
                        padding: EdgeInsets(top: 5, leading: 9, bottom: 5, trailing: 9)
                    )
                )
        }
        .buttonStyle(.plain)
        .spaceHoverEffect()
        .animation(.interactiveSpring, value: isOn)
        .environment(\.spaceChipStyleOverride, nil)
    }

    @ViewBuilder
    private var chipLabel: some View {
        let text = isOn ? onText : offText
        let icon = isOn ? onIcon : offIcon

        if let icon {
            Label(text, systemImage: icon)
        } else {
            Text(text)
        }
    }

    private func foregroundColor(for style: SpaceUIStyle) -> Color {
        guard style.highlighted else {
            return .white.opacity(0.62)
        }

        return style.role == .normal ? .white : tokens.color(for: style.role)
    }
}

// MARK: - SpaceIconButton

public struct SpaceIconButton: View {
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceIconButtonStyleOverride) private var iconButtonStyleOverride
    @Environment(\.spaceStyleTokens) private var tokens

    private var systemName: String
    private var accessibilityLabel: String?
    private var size: CGFloat
    private var action: @MainActor () -> Void

    public init(
        _ systemName: String,
        size: CGFloat = 50,
        accessibilityLabel: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.systemName = systemName
        self.size = size
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        let resolvedStyle = (iconButtonStyleOverride ?? inheritedStyle ?? .glass)

        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundStyle(foregroundColor(for: resolvedStyle))
                .contentTransition(.symbolEffect)
                .frame(width: size, height: size)
                .modifier(
                    SpaceShapeSurfaceModifier(
                        shape: Circle(),
                        style: resolvedStyle,
                        padding: EdgeInsets()
                    )
                )
                .animation(.interactiveSpring, value: systemName)
        }
        .buttonStyle(.plain)
        .spaceHoverEffect()
        .accessibilityLabel(Text(accessibilityLabel ?? systemName))
        .environment(\.spaceIconButtonStyleOverride, nil)
    }

    private func foregroundColor(for style: SpaceUIStyle) -> Color {
        guard style.highlighted else {
            return .white.opacity(0.62)
        }

        return style.role == .normal ? tokens.color(for: .normal) : tokens.color(for: style.role)
    }
}

// MARK: - SpaceButtonTwoStep

public struct SpaceButtonTwoStep<L: View, Trigger: Equatable>: View {
    let label: () -> L
    
    let action: @MainActor () -> Void
    let confirmAction: @MainActor () -> Void
    
    var role: SpaceUIRole?
    var disarmTrigger: Trigger
    
    @State private var isArmed: Bool = false
    
    public init(
        role: SpaceUIRole? = nil,
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
        role: SpaceUIRole? = nil,
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
        role: SpaceUIRole? = nil,
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
        role: SpaceUIRole? = nil,
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
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceTextFieldStyleOverride) private var textFieldStyleOverride

    var titleKey: String? = nil
    var placeholder: String = ""
    @Binding public var text: String
    var role: SpaceUIRole?
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
    
    public init(_ titleKey: String, text: Binding<String>, placeholder: String = "", role: SpaceUIRole? = nil, highlighted: Bool? = nil) {
        self._text = text
        self.titleKey = titleKey
        self.placeholder = placeholder
        self.highlighted = highlighted
        self.role = role
    }
    
    public init(text: Binding<String>, placeholder: String = "", role: SpaceUIRole? = nil, highlighted: Bool? = nil) {
        self._text = text
        self.titleKey = nil
        self.placeholder = placeholder
        self.highlighted = highlighted
        self.role = role
    }
    
    public var body: some View {
        let resolvedStyle = (textFieldStyleOverride ?? inheritedStyle ?? .primary)
            .resolving(role: role, highlighted: highlighted)

        SpaceCard {
            VStack(alignment: .leading) {
                if let titleKey {
                    Text(titleKey)
                        .spaceSubtitle(.orbitronMedium)
                }
                TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundStyle(.gray))
                    .textFieldStyle(.plain)
                    .spaceSubtitle()
            }
        }
        .spaceCardStyle(resolvedStyle)
        .environment(\.spaceTextFieldStyleOverride, nil)
    }
}

// MARK: - SpacePanel

public struct SpacePanel<Content: View>: View {
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spacePanelStyleOverride) private var panelStyleOverride
    @Environment(\.spaceStyleTokens) private var tokens

    var content: Content
    var role: SpaceUIRole?
    var highlighted: Bool?
    private var customColor: Color?

    var color: Color {
        customColor ?? (role ?? .normal).color
    }

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.role = nil
        self.highlighted = nil
        self.customColor = nil
    }
    
    public init(role: SpaceUIRole, highlighted: Bool? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.role = role
        self.highlighted = highlighted
        self.customColor = nil
    }
    
    public init(color: Color, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.role = nil
        self.highlighted = nil
        self.customColor = color
    }

    public var body: some View {
        let resolvedStyle = (panelStyleOverride ?? inheritedStyle ?? .glass)
            .resolving(role: role, highlighted: highlighted)

        VStack {
            content
        }
        .modifier(
            SpaceSurfaceModifier(
                style: customColor == nil
                    ? resolvedStyle
                    : .glass(role: .normal, highlighted: resolvedStyle.highlighted),
                cornerRadius: tokens.panelCornerRadius,
                padding: EdgeInsets(
                    top: tokens.panelPadding,
                    leading: tokens.panelPadding,
                    bottom: tokens.panelPadding,
                    trailing: tokens.panelPadding
                )
            )
        )
        .overlay {
            if let customColor {
                RoundedRectangle(cornerRadius: tokens.panelCornerRadius)
                    .stroke(customColor, lineWidth: 1)
            }
        }
        .environment(\.spacePanelStyleOverride, nil)
    }
}

// MARK: - SpaceCard

public struct SpaceCard<Content: View>: View {
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceCardStyleOverride) private var cardStyleOverride
    
    var content: Content
    var highlighted: Bool?
    var role: SpaceUIRole?
    
    public init(highlighted: Bool? = nil, role: SpaceUIRole? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.highlighted = highlighted
        self.role = role
    }
    
    public init(title: String, subtitle: String, role: SpaceUIRole? = nil, highlighted: Bool? = nil) where Content == VStack<TupleView<(AnyView, AnyView)>> {
        self.content = VStack(alignment: .leading) {
            AnyView(Text(title).spaceTitle())
            AnyView(Text(subtitle).spaceSubtitle())
        }
        self.highlighted = highlighted
        self.role = role
    }
    
    public init(title2: String, subtitle: String, role: SpaceUIRole? = nil, highlighted: Bool? = nil) where Content == VStack<TupleView<(AnyView, AnyView)>> {
        self.content = VStack(alignment: .leading) {
            AnyView(Text(title2).spaceTitle2())
            AnyView(Text(subtitle).spaceSubtitle())
        }
        self.highlighted = highlighted
        self.role = role
    }
    
    public var body: some View {
        let resolvedStyle = (cardStyleOverride ?? inheritedStyle ?? .primary)
            .resolving(role: role, highlighted: highlighted)

        VStack {
            content
        }
        .modifier(SpaceSurfaceModifier(style: resolvedStyle, cornerRadius: nil, padding: nil))
        .environment(\.spaceCardStyleOverride, nil)
    }
}

// MARK: - SpaceListRow

public struct SpaceListRow<Content: View>: View {
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceListRowStyleOverride) private var listRowStyleOverride

    private var content: Content
    private var role: SpaceUIRole?
    private var highlighted: Bool?
    private var selected: Bool
    private var isDisabled: Bool
    private var action: (@MainActor () -> Void)?

    // Generic content init
    public init(
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        selected: Bool = false,
        disabled: Bool = false,
        action: (@MainActor () -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.role = role
        self.highlighted = highlighted
        self.selected = selected
        self.isDisabled = disabled
        self.action = action
    }

    // Single string
    public init(
        _ text: String,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        selected: Bool = false,
        disabled: Bool = false,
        action: (@MainActor () -> Void)? = nil
    ) where Content == HStack<TupleView<(AnyView, Spacer)>> {
        self.content = HStack {
            AnyView(Text(text).spaceSubtitle())
            Spacer()
        }
        self.role = role
        self.highlighted = highlighted
        self.selected = selected
        self.isDisabled = disabled
        self.action = action
    }

    // Title + subtitle strings
    public init(
        title: String,
        subtitle: String,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        selected: Bool = false,
        disabled: Bool = false,
        action: (@MainActor () -> Void)? = nil
    ) where Content == HStack<TupleView<(AnyView, Spacer, AnyView)>> {
        self.content = HStack {
            AnyView(Text(title).spaceTextBody(.spaceGroteskMedium, color: .white))
            Spacer()
            AnyView(Text(subtitle).spaceSubtitle())
        }
        self.role = role
        self.highlighted = highlighted
        self.selected = selected
        self.isDisabled = disabled
        self.action = action
    }

    public init(
        title: String,
        status: String,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        selected: Bool = false,
        disabled: Bool = false,
        action: (@MainActor () -> Void)? = nil
    ) where Content == HStack<TupleView<(AnyView, Spacer, AnyView)>> {
        self.content = HStack {
            AnyView(Text(title).spaceTextBody(.spaceGroteskMedium, color: .white))
            Spacer()
            AnyView(
                Text(status)
                    .spaceTextBody(.orbitronMedium, color: selected ? .yellow : .cyan)
                    .spaceGlow(active: !disabled)
                    .opacity(disabled && !selected ? 0.3 : 1)
            )
        }
        self.role = role
        self.highlighted = highlighted
        self.selected = selected
        self.isDisabled = disabled
        self.action = action
    }

    // Title + subtitle views
    public init(
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        selected: Bool = false,
        disabled: Bool = false,
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
        self.selected = selected
        self.isDisabled = disabled
        self.action = action
    }

    // Title + subtitle view builders
    public init(
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        selected: Bool = false,
        disabled: Bool = false,
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
        self.selected = selected
        self.isDisabled = disabled
        self.action = action
    }

    public var body: some View {
        let resolvedStyle = (listRowStyleOverride ?? inheritedStyle ?? .primary)
            .resolving(role: role, highlighted: highlighted)

        let row = HStack {
            content
            Spacer()
        }
        .modifier(SpaceListRowSurfaceModifier(style: resolvedStyle, selected: selected))
        .opacity(isDisabled ? 0.65 : 1)

        let card = row
        if let action {
            Button(action: action) { card }
                .buttonStyle(SpacePressStyle(highlighted: resolvedStyle.highlighted))
                .spaceHoverEffect()
                .disabled(isDisabled)
                .environment(\.spaceListRowStyleOverride, nil)
        } else {
            card
                .environment(\.spaceListRowStyleOverride, nil)
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

public struct SpaceJoystick: View {
    @Binding public var offset: CGSize
    
    public var size: CGFloat
    public var thumbSize: CGFloat
    public var maxRadius: CGFloat
    public var minDistance: CGFloat
    public var margin: CGFloat
    @State private var joystickActive = false
    
    public init(
        offset: Binding<CGSize>,
        size: CGFloat = 220,
        thumbSize: CGFloat = 100,
        maxRadius: CGFloat = 60,
        minDistance: CGFloat = 0,
        margin: CGFloat = 20
    ) {
        self._offset = offset
        self.size = size
        self.thumbSize = thumbSize
        self.maxRadius = maxRadius
        self.minDistance = minDistance
        self.margin = margin
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.cyan.opacity(joystickActive ? 0.45 : 0.12),
                    lineWidth: 1.5
                )
                .frame(width: size + 24, height: size + 24)
                .animation(.easeInOut(duration: 0.15), value: joystickActive)

            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
            
            ForEach([0, 90, 180, 270], id: \.self) { deg in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 2, height: 10)
                    .offset(y: -(size / 2) + 15)
                    .rotationEffect(.degrees(Double(deg)))
            }

            Circle()
                .fill(
                    joystickActive
                    ? Color.cyan.opacity(0.25)
                    : Color.white.opacity(0.07)
                )
                .frame(width: thumbSize, height: thumbSize)
                .overlay(
                    Circle()
                        .stroke(
                            Color.cyan.opacity(joystickActive ? 0.7 : 0.2),
                            lineWidth: 1.5
                        )
                )
                .shadow(
                    color: joystickActive
                    ? .cyan.opacity(0.5)
                    : .clear,
                    radius: 18
                )
                .offset(offset)
                .animation(
                    .interpolatingSpring,
                    value: joystickActive
                )
        }
        .gesture(
            DragGesture(minimumDistance: minDistance)
                .onChanged { value in
                    joystickActive = true
                    
                    var dx = value.translation.width
                    var dy = value.translation.height
                    
                    let distance = sqrt(dx * dx + dy * dy)
                    
                    if distance > maxRadius + margin {
                        dx = dx / distance * (maxRadius + margin)
                        dy = dy / distance * (maxRadius + margin)
                    }
                    
                    offset = CGSize(width: dx, height: dy)
                }
                .onEnded { _ in
                    joystickActive = false
                    withAnimation(.interactiveSpring(response: 0.25)) {
                        offset = .zero
                    }
                }
        )
    }
}

public extension View {
    func spaceModal<Content: View>(
        isPresented: Binding<Bool>,
        disableBackgroundInteraction: Bool,
        tapOutsideToDismiss: Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .blur(radius: isPresented.wrappedValue ? 10 : 0)
            .allowsHitTesting(!(isPresented.wrappedValue && disableBackgroundInteraction))
            .overlay {
                if isPresented.wrappedValue {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if tapOutsideToDismiss {
                                    withAnimation {
                                        isPresented.wrappedValue = false
                                    }
                                }
                            }

                        content()
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isPresented.wrappedValue)
    }
}
public extension View {
    func spaceAlert<Actions: View>(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        disableBackgroundInteraction: Bool = true,
        tapOutsideToDismiss: Bool = true,
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) -> some View {

        self.spaceModal(
            isPresented: isPresented,
            disableBackgroundInteraction: disableBackgroundInteraction,
            tapOutsideToDismiss: tapOutsideToDismiss
        ) {
            SpaceAlert(
                title: title,
                subtitle: subtitle,
                role: role,
                highlighted: highlighted,
                actions: actions
            )
        }
    }
    func spaceAlert<Label: View, Actions: View>(
        isPresented: Binding<Bool>,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        disableBackgroundInteraction: Bool = true,
        tapOutsideToDismiss: Bool = true,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) -> some View {

        self.spaceModal(
            isPresented: isPresented,
            disableBackgroundInteraction: disableBackgroundInteraction,
            tapOutsideToDismiss: tapOutsideToDismiss
        ) {
            SpaceAlert(
                role: role,
                highlighted: highlighted,
                label: label,
                actions: actions
            )
        }
    }
}
public struct SpaceAlert<Label: View, Actions: View>: View {
    var label: Label
    var actions: Actions
    var role: SpaceUIRole?
    var highlighted: Bool?
    
    public init(
        title: String,
        subtitle: String,
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) where Label == VStack<TupleView<(SpaceTitle, SpaceSubtitle)>> {
        self.label = VStack {
            SpaceTitle(title)
            SpaceSubtitle(subtitle)
        }
        self.actions = actions()
        self.role = role
        self.highlighted = highlighted
    }
    
    public init(
        role: SpaceUIRole? = nil,
        highlighted: Bool? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) {
        self.label = label()
        self.actions = actions()
        self.role = role
        self.highlighted = highlighted
    }
    
    public var body: some View {
        SpaceCard(highlighted: highlighted, role: role) {
            label
            actions
        }
    }
}

public struct SpaceDropdown<Label: View, Content: View>: View {
    var label: Label
    var content: Content
    @State private var isOpen: Bool = false
    var highlighted: Bool?
    var role: SpaceUIRole?
    
    public init(
        _ title: String,
        highlighted: Bool? = nil,
        role: SpaceUIRole? = nil,
        @ViewBuilder content: () -> Content
    ) where Label == SpaceText {
        self.label = SpaceText(title)
        self.content = content()
        self.highlighted = highlighted
        self.role = role
    }
    public init(
        highlighted: Bool? = nil,
        role: SpaceUIRole? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label()
        self.content = content()
        self.highlighted = highlighted
        self.role = role
    }
    
    public var body: some View {
        SpaceButton(role: role, highlighted: highlighted) {
            isOpen.toggle()
        } label: {
            VStack(alignment: .leading) {
                label
                if isOpen {
                    content
                        .clipped()
                        .transition(
                            .asymmetric(
                                insertion: .push(from: .top),
                                removal: .push(from: .bottom)
                            )
                        )
                }
            }
        }
        .animation(.interpolatingSpring, value: isOpen)
    }
}

// MARK: - Preview

struct SpaceUIPreview: View {
    init() { SpaceFont.register() }
    
    @State private var isOn: Bool = false
    @State private var text: String = ""
    @State private var counter: CGFloat = 0
    @State private var joystickPosition: CGSize = .zero
    @State private var showAlert: Bool = false
    @State private var isPublic: Bool = false
    
    var body: some View {
        SpaceContainer(spacing: 20) {
            SpaceContainer(spacing: 6) {
                Text("SpaceUI").spaceTextStyle(.title)
                Text("Simple SpaceUI showcase").spaceTextStyle(.subtitle)
            }
            SpaceCard(title: "Space UI", subtitle: "Space UI is a custom UI style that feels sci-fi")
                .spaceUIStyle(.glass(role: .confirm, highlighted: true))
            SpaceCard {
                HStack {
                    SpaceChip("PUBLIC", isOn: $isPublic, icon: "antenna.radiowaves.left.and.right")
                        .spaceChipStyle(.glass(role: .confirm))
                    Spacer()
                    SpaceIconButton("xmark", accessibilityLabel: "Close") {
                        isPublic = false
                    }
                    .spaceIconButtonStyle(.glass(role: .destructive))
                }
            }
            .spaceUIStyle(.glass)
            SpaceToggle("Space Toggle Button", isOn: $isOn)
            SpaceButton("increment") {
                counter += 0.05
            }
            SpaceButtonTwoStep("Two step", disarmTrigger: isOn) {
                print("action activated")
            }
            SpaceTextField("Space Text Field", text: $text, placeholder: "Type text here")
                .spaceUIStyle(.glass)
            SpaceSection("Space Section") {
                SpaceListRow(title: "Space row Title", subtitle: "subtitle")
                    .spaceUIStyle(.glass)
                SpaceListRow(title: "Tappable row", subtitle: "JOIN") {
                    showAlert = true
                }
                .spaceUIStyle(.glass(role: .confirm, highlighted: true))
                SpaceListRow(
                    title: Text("server1").spaceTextStyle(.subtitle, font: .orbitronMedium),
                    subtitle: Text("JOIN").spaceTextStyle(.subtitle, color: .cyan)
                )
                SpaceListRow {
                    SpaceSegmentedProgressView(counter, segments: 5)
                        .animation(.easeOut(duration: 0.2), value: counter)
                }
                SpaceListRow {
                    SpaceText("Hello")
                    SpaceText("Hello2")
                }
            }
            SpacePanel {
                SpaceTitle("this is a panel")
                Text("this is very small text")
                    .spaceTextStyle(1, font: .orbitronMedium)
            }
            SpaceDropdown("This is a dropdown") {
                SpaceJoystick(offset: $joystickPosition)
            }
        }
        .adaptiveScrollView()
        .spaceBackground()
        .spaceAlert(isPresented: $showAlert) {
            SpaceTitle("Hi")
        }
    }
}

#Preview("SpaceUI Preview") {
    SpaceUIPreview()
}
#Preview("SpaceUI 2") {
    @Previewable @State var focusedSide: SpaceSplitSide = .left
    SpaceSplitView(
        initialSide: .right,
        dimming: false,
        leftContent: {
            Text("Press here to begin")
                .spacePulse()
        }, rightContent: {
            
        })
    .ignoresSafeArea()
    .spaceBackground(animated: true)
}
