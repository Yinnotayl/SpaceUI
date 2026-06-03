import SwiftUI

public enum SpaceUIStyle {
    case primary(role: SpaceUIRole = .normal, highlighted: Bool = false)
    case glass(role: SpaceUIRole = .normal, highlighted: Bool = false)

    public static var primary: SpaceUIStyle {
        .primary()
    }

    public static var glass: SpaceUIStyle {
        .glass()
    }
}

enum SpaceUIStyleKind {
    case primary
    case glass
}

public struct SpaceUIStyleTokens {
    public var normalColor: Color
    public var confirmColor: Color
    public var destructiveColor: Color

    public var normalGradient: [Color]
    public var confirmGradient: [Color]
    public var destructiveGradient: [Color]

    public var cornerRadius: CGFloat
    public var panelCornerRadius: CGFloat
    public var rowCornerRadius: CGFloat
    public var surfacePadding: CGFloat
    public var panelPadding: CGFloat
    public var rowHorizontalPadding: CGFloat
    public var rowVerticalPadding: CGFloat

    public var primaryFillOpacity: Double
    public var primaryHighlightedFillOpacity: Double
    public var glassFillOpacity: Double
    public var glassHighlightedFillOpacity: Double
    public var glassRoleTintOpacity: Double
    public var glassHighlightedRoleTintOpacity: Double

    public var borderOpacity: Double
    public var highlightedBorderOpacity: Double
    public var borderWidth: CGFloat
    public var highlightedBorderWidth: CGFloat
    public var highlightedShadowOpacity: Double
    public var highlightedShadowRadius: CGFloat

    public var rowGlassFillOpacity: Double
    public var rowGlassSelectedFillOpacity: Double
    public var rowGlassBorderOpacity: Double
    public var rowGlassSelectedBorderOpacity: Double

    public init(
        normalColor: Color = .cyan,
        confirmColor: Color = .blue,
        destructiveColor: Color = .red,
        normalGradient: [Color] = [.teal, .cyan],
        confirmGradient: [Color] = [.mint, .indigo],
        destructiveGradient: [Color] = [.red, .pink],
        cornerRadius: CGFloat = 14,
        panelCornerRadius: CGFloat = 12,
        rowCornerRadius: CGFloat = 10,
        surfacePadding: CGFloat = 16,
        panelPadding: CGFloat = 16,
        rowHorizontalPadding: CGFloat = 12,
        rowVerticalPadding: CGFloat = 10,
        primaryFillOpacity: Double = 0.4,
        primaryHighlightedFillOpacity: Double = 0.46,
        glassFillOpacity: Double = 0.04,
        glassHighlightedFillOpacity: Double = 0.12,
        glassRoleTintOpacity: Double = 0.06,
        glassHighlightedRoleTintOpacity: Double = 0.075,
        borderOpacity: Double = 0.7,
        highlightedBorderOpacity: Double = 1,
        borderWidth: CGFloat = 1,
        highlightedBorderWidth: CGFloat = 2,
        highlightedShadowOpacity: Double = 0.8,
        highlightedShadowRadius: CGFloat = 25,
        rowGlassFillOpacity: Double = 0.04,
        rowGlassSelectedFillOpacity: Double = 0.12,
        rowGlassBorderOpacity: Double = 0.1,
        rowGlassSelectedBorderOpacity: Double = 0.6
    ) {
        self.normalColor = normalColor
        self.confirmColor = confirmColor
        self.destructiveColor = destructiveColor
        self.normalGradient = normalGradient
        self.confirmGradient = confirmGradient
        self.destructiveGradient = destructiveGradient
        self.cornerRadius = cornerRadius
        self.panelCornerRadius = panelCornerRadius
        self.rowCornerRadius = rowCornerRadius
        self.surfacePadding = surfacePadding
        self.panelPadding = panelPadding
        self.rowHorizontalPadding = rowHorizontalPadding
        self.rowVerticalPadding = rowVerticalPadding
        self.primaryFillOpacity = primaryFillOpacity
        self.primaryHighlightedFillOpacity = primaryHighlightedFillOpacity
        self.glassFillOpacity = glassFillOpacity
        self.glassHighlightedFillOpacity = glassHighlightedFillOpacity
        self.glassRoleTintOpacity = glassRoleTintOpacity
        self.glassHighlightedRoleTintOpacity = glassHighlightedRoleTintOpacity
        self.borderOpacity = borderOpacity
        self.highlightedBorderOpacity = highlightedBorderOpacity
        self.borderWidth = borderWidth
        self.highlightedBorderWidth = highlightedBorderWidth
        self.highlightedShadowOpacity = highlightedShadowOpacity
        self.highlightedShadowRadius = highlightedShadowRadius
        self.rowGlassFillOpacity = rowGlassFillOpacity
        self.rowGlassSelectedFillOpacity = rowGlassSelectedFillOpacity
        self.rowGlassBorderOpacity = rowGlassBorderOpacity
        self.rowGlassSelectedBorderOpacity = rowGlassSelectedBorderOpacity
    }

    public func color(for role: SpaceUIRole) -> Color {
        switch role {
        case .normal:
            return normalColor
        case .confirm:
            return confirmColor
        case .destructive:
            return destructiveColor
        }
    }

    public func gradientColors(for role: SpaceUIRole) -> [Color] {
        switch role {
        case .normal:
            return normalGradient
        case .confirm:
            return confirmGradient
        case .destructive:
            return destructiveGradient
        }
    }

    func linearGradient(for role: SpaceUIRole) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: gradientColors(for: role)),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    func angularGradient(for role: SpaceUIRole, angle: Angle) -> AngularGradient {
        let colors = gradientColors(for: role)
        let first = colors.first ?? color(for: role)
        let second = colors.dropFirst().first ?? first
        return AngularGradient(
            colors: [first, second, second, first],
            center: .center,
            angle: angle
        )
    }
}

private struct SpaceInheritedStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpaceStyleTokensKey: EnvironmentKey {
    static let defaultValue = SpaceUIStyleTokens()
}

private struct SpaceCardStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpaceButtonStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpaceListRowStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpacePanelStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpaceTextFieldStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpaceChipStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

private struct SpaceIconButtonStyleKey: EnvironmentKey {
    static let defaultValue: SpaceUIStyle? = nil
}

extension EnvironmentValues {
    var spaceInheritedStyle: SpaceUIStyle? {
        get { self[SpaceInheritedStyleKey.self] }
        set { self[SpaceInheritedStyleKey.self] = newValue }
    }

    var spaceCardStyleOverride: SpaceUIStyle? {
        get { self[SpaceCardStyleKey.self] }
        set { self[SpaceCardStyleKey.self] = newValue }
    }

    var spaceButtonStyleOverride: SpaceUIStyle? {
        get { self[SpaceButtonStyleKey.self] }
        set { self[SpaceButtonStyleKey.self] = newValue }
    }

    var spaceListRowStyleOverride: SpaceUIStyle? {
        get { self[SpaceListRowStyleKey.self] }
        set { self[SpaceListRowStyleKey.self] = newValue }
    }

    var spacePanelStyleOverride: SpaceUIStyle? {
        get { self[SpacePanelStyleKey.self] }
        set { self[SpacePanelStyleKey.self] = newValue }
    }

    var spaceTextFieldStyleOverride: SpaceUIStyle? {
        get { self[SpaceTextFieldStyleKey.self] }
        set { self[SpaceTextFieldStyleKey.self] = newValue }
    }

    var spaceChipStyleOverride: SpaceUIStyle? {
        get { self[SpaceChipStyleKey.self] }
        set { self[SpaceChipStyleKey.self] = newValue }
    }

    var spaceIconButtonStyleOverride: SpaceUIStyle? {
        get { self[SpaceIconButtonStyleKey.self] }
        set { self[SpaceIconButtonStyleKey.self] = newValue }
    }
}

public extension EnvironmentValues {
    var spaceStyleTokens: SpaceUIStyleTokens {
        get { self[SpaceStyleTokensKey.self] }
        set { self[SpaceStyleTokensKey.self] = newValue }
    }
}

public extension View {
    func spaceUIStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceInheritedStyle, style)
    }

    func spaceStyleTokens(_ tokens: SpaceUIStyleTokens) -> some View {
        environment(\.spaceStyleTokens, tokens)
    }

    func spaceCardStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceCardStyleOverride, style)
    }

    func spaceButtonStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceButtonStyleOverride, style)
    }

    func spaceListRowStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceListRowStyleOverride, style)
    }

    func spacePanelStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spacePanelStyleOverride, style)
    }

    func spaceTextFieldStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceTextFieldStyleOverride, style)
    }

    func spaceChipStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceChipStyleOverride, style)
    }

    func spaceIconButtonStyle(_ style: SpaceUIStyle) -> some View {
        environment(\.spaceIconButtonStyleOverride, style)
    }
}

extension SpaceUIStyle {
    var kind: SpaceUIStyleKind {
        switch self {
        case .primary:
            return .primary
        case .glass:
            return .glass
        }
    }

    var role: SpaceUIRole {
        switch self {
        case .primary(let role, _), .glass(let role, _):
            return role
        }
    }

    var highlighted: Bool {
        switch self {
        case .primary(_, let highlighted), .glass(_, let highlighted):
            return highlighted
        }
    }

    func resolving(role roleOverride: SpaceUIRole?, highlighted highlightedOverride: Bool?) -> SpaceUIStyle {
        switch self {
        case .primary(let role, let highlighted):
            return .primary(
                role: roleOverride ?? role,
                highlighted: highlightedOverride ?? highlighted
            )
        case .glass(let role, let highlighted):
            return .glass(
                role: roleOverride ?? role,
                highlighted: highlightedOverride ?? highlighted
            )
        }
    }
}

struct SpaceSurfaceModifier: ViewModifier {
    @Environment(\.spaceStyleTokens) private var tokens

    let style: SpaceUIStyle
    var cornerRadius: CGFloat?
    var padding: EdgeInsets?

    @State private var rotation: Double = 0

    func body(content: Content) -> some View {
        let cornerRadius = cornerRadius ?? tokens.cornerRadius
        let padding = padding ?? EdgeInsets(
            top: tokens.surfacePadding,
            leading: tokens.surfacePadding,
            bottom: tokens.surfacePadding,
            trailing: tokens.surfacePadding
        )

        content
            .padding(padding)
            .background {
                surfaceBackground(cornerRadius: cornerRadius)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderStyle, lineWidth: borderWidth)
            }
            .shadow(
                color: style.highlighted
                    ? tokens.color(for: style.role).opacity(tokens.highlightedShadowOpacity)
                    : .clear,
                radius: style.highlighted ? tokens.highlightedShadowRadius : 0
            )
            .animation(.bouncy, value: style.highlighted)
            .onAppear(perform: startBorderAnimationIfNeeded)
            .onChange(of: style.highlighted) { _, isHighlighted in
                if isHighlighted {
                    rotation = 0
                    startBorderAnimationIfNeeded()
                }
            }
    }

    private var borderWidth: CGFloat {
        style.highlighted ? tokens.highlightedBorderWidth : tokens.borderWidth
    }

    private var borderStyle: AnyShapeStyle {
        if style.highlighted {
            return AnyShapeStyle(
                tokens.angularGradient(for: style.role, angle: .degrees(rotation))
                    .opacity(tokens.highlightedBorderOpacity)
            )
        }

        switch style.kind {
        case .primary:
            return AnyShapeStyle(
                tokens.linearGradient(for: style.role)
                    .opacity(tokens.borderOpacity)
            )
        case .glass:
            return AnyShapeStyle(
                glassTintColor.opacity(
                    style.role == .normal
                        ? tokens.rowGlassBorderOpacity
                        : tokens.rowGlassBorderOpacity + 0.08
                )
            )
        }
    }

    @ViewBuilder
    private func surfaceBackground(cornerRadius: CGFloat) -> some View {
        ZStack {
            switch style.kind {
            case .primary:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        Color.black.opacity(
                            style.highlighted
                                ? tokens.primaryHighlightedFillOpacity
                                : tokens.primaryFillOpacity
                        )
                    )
            case .glass:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        Color.white.opacity(
                            style.highlighted
                                ? tokens.glassHighlightedFillOpacity
                                : tokens.glassFillOpacity
                        )
                    )
                if style.role != .normal {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            tokens.color(for: style.role).opacity(
                                style.highlighted
                                    ? tokens.glassHighlightedRoleTintOpacity
                                    : tokens.glassRoleTintOpacity
                            )
                        )
                }
            }
        }
    }

    private var glassTintColor: Color {
        style.role == .normal ? .white : tokens.color(for: style.role)
    }

    private func startBorderAnimationIfNeeded() {
        guard style.highlighted else { return }
        withAnimation(.linear(duration: 4.5).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}

struct SpaceListRowSurfaceModifier: ViewModifier {
    @Environment(\.spaceStyleTokens) private var tokens

    let style: SpaceUIStyle
    var selected: Bool

    @State private var rotation: Double = 0

    @ViewBuilder
    func body(content: Content) -> some View {
        switch style.kind {
        case .primary:
            content.modifier(
                SpaceSurfaceModifier(
                    style: style,
                    cornerRadius: tokens.cornerRadius,
                    padding: EdgeInsets(
                        top: tokens.surfacePadding,
                        leading: tokens.surfacePadding,
                        bottom: tokens.surfacePadding,
                        trailing: tokens.surfacePadding
                    )
                )
            )
        case .glass:
            content
                .padding(.horizontal, tokens.rowHorizontalPadding)
                .padding(.vertical, tokens.rowVerticalPadding)
                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: tokens.rowCornerRadius)
                            .fill(
                                Color.white.opacity(
                                    selected || style.highlighted
                                        ? tokens.rowGlassSelectedFillOpacity
                                        : tokens.rowGlassFillOpacity
                                )
                            )
                        if style.role != .normal {
                            RoundedRectangle(cornerRadius: tokens.rowCornerRadius)
                                .fill(
                                    tokens.color(for: style.role).opacity(
                                        selected || style.highlighted
                                            ? tokens.glassHighlightedRoleTintOpacity
                                            : tokens.glassRoleTintOpacity
                                    )
                                )
                        }
                        RoundedRectangle(cornerRadius: tokens.rowCornerRadius)
                            .strokeBorder(rowBorderStyle, lineWidth: rowBorderWidth)
                    }
                }
                .shadow(
                    color: style.highlighted
                        ? tokens.color(for: style.role).opacity(tokens.highlightedShadowOpacity * 0.45)
                        : .clear,
                    radius: style.highlighted ? 12 : 0
                )
                .onAppear(perform: startBorderAnimationIfNeeded)
                .onChange(of: style.highlighted) { _, isHighlighted in
                    if isHighlighted {
                        rotation = 0
                        startBorderAnimationIfNeeded()
                    }
                }
        }
    }

    private var rowBorderWidth: CGFloat {
        style.highlighted ? tokens.highlightedBorderWidth : tokens.borderWidth
    }

    private var rowBorderStyle: AnyShapeStyle {
        if style.highlighted {
            return AnyShapeStyle(
                tokens.angularGradient(for: style.role, angle: .degrees(rotation))
                    .opacity(tokens.highlightedBorderOpacity)
            )
        }

        return AnyShapeStyle(
            (style.role == .normal ? Color.white : tokens.color(for: style.role))
                .opacity(
                    selected
                        ? tokens.rowGlassSelectedBorderOpacity
                        : tokens.rowGlassBorderOpacity
                )
        )
    }

    private func startBorderAnimationIfNeeded() {
        guard style.highlighted else { return }
        withAnimation(.linear(duration: 4.5).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}

struct SpaceShapeSurfaceModifier<S: InsettableShape>: ViewModifier {
    @Environment(\.spaceStyleTokens) private var tokens

    let shape: S
    let style: SpaceUIStyle
    var padding: EdgeInsets

    @State private var rotation: Double = 0

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                shapeBackground
            }
            .overlay {
                shape.strokeBorder(borderStyle, lineWidth: borderWidth)
            }
            .shadow(
                color: style.highlighted
                    ? tokens.color(for: style.role).opacity(tokens.highlightedShadowOpacity * 0.45)
                    : .clear,
                radius: style.highlighted ? 12 : 0
            )
            .animation(.bouncy, value: style.highlighted)
            .onAppear(perform: startBorderAnimationIfNeeded)
            .onChange(of: style.highlighted) { _, isHighlighted in
                if isHighlighted {
                    rotation = 0
                    startBorderAnimationIfNeeded()
                }
            }
    }

    private var borderWidth: CGFloat {
        style.highlighted ? tokens.highlightedBorderWidth : tokens.borderWidth
    }

    private var borderStyle: AnyShapeStyle {
        if style.highlighted {
            return AnyShapeStyle(
                tokens.angularGradient(for: style.role, angle: .degrees(rotation))
                    .opacity(tokens.highlightedBorderOpacity)
            )
        }

        switch style.kind {
        case .primary:
            return AnyShapeStyle(tokens.linearGradient(for: style.role).opacity(tokens.borderOpacity))
        case .glass:
            return AnyShapeStyle(glassTintColor.opacity(glassBorderOpacity))
        }
    }

    @ViewBuilder
    private var shapeBackground: some View {
        ZStack {
            switch style.kind {
            case .primary:
                shape.fill(
                    Color.black.opacity(
                        style.highlighted
                            ? tokens.primaryHighlightedFillOpacity
                            : tokens.primaryFillOpacity
                    )
                )
            case .glass:
                shape.fill(
                    Color.white.opacity(
                        style.highlighted
                            ? tokens.glassHighlightedFillOpacity
                            : tokens.glassFillOpacity
                    )
                )
                if style.role != .normal {
                    shape.fill(
                        tokens.color(for: style.role).opacity(
                            style.highlighted
                                ? tokens.glassHighlightedRoleTintOpacity
                                : tokens.glassRoleTintOpacity
                        )
                    )
                }
            }
        }
    }

    private var glassTintColor: Color {
        style.role == .normal ? .white : tokens.color(for: style.role)
    }

    private var glassBorderOpacity: Double {
        style.role == .normal ? tokens.rowGlassBorderOpacity : tokens.rowGlassBorderOpacity + 0.08
    }

    private func startBorderAnimationIfNeeded() {
        guard style.highlighted else { return }
        withAnimation(.linear(duration: 4.5).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}
