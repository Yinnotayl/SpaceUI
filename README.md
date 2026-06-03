# SpaceUI

A custom space / sci-fi UI component library for SwiftUI apps.

## Requirements

- iOS 17+ / macOS 14+ / tvOS 17+ / watchOS 10+
- Swift 5.9+

## Installation

```swift
.package(url: "https://github.com/Yinnotayl/SpaceUI", branch: "main")
```

Add `"SpaceUI"` as a dependency to your target.

## Setup

Register SpaceUI fonts once at app launch:

```swift
import SpaceUI

@main
struct MyApp: App {
    init() {
        SpaceFont.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

## Styles

SpaceUI components can inherit a shared style:

```swift
VStack {
    SpaceCard {
        SpaceText("Mission Control")
    }

    SpaceButton("Deploy") {
        deploy()
    }
    .spaceUIStyle(.primary(role: .confirm))
}
.spaceUIStyle(.primary)
```

Use scoped modifiers when one component should differ without restyling nested SpaceUI elements:

```swift
SpaceCard {
    SpaceButton("Join") {
        join()
    }
}
.spaceCardStyle(.glass(role: .confirm, highlighted: true))
```

Available styles:

```swift
.primary
.glass
.primary(role: .normal, highlighted: false)
.glass(role: .confirm, highlighted: true)
```

Scoped modifiers:

```swift
.spaceCardStyle(.glass)
.spaceListRowStyle(.glass)
.spacePanelStyle(.glass)
.spaceButtonStyle(.primary(role: .confirm))
.spaceTextFieldStyle(.glass)
.spaceChipStyle(.glass(role: .confirm))
.spaceIconButtonStyle(.glass(role: .destructive))
```

You can tune the shared style variables with `SpaceUIStyleTokens`:

```swift
ContentView()
    .spaceStyleTokens(
        SpaceUIStyleTokens(
            normalColor: .cyan,
            confirmColor: .mint,
            destructiveColor: .red
        )
    )
```

## Typography

SpaceUI ships Orbitron and Space Grotesk variants. Display/title/action text defaults to Orbitron; subtitle/body/caption text defaults to Space Grotesk.
Space Grotesk styles do not add letter tracking by default.

Semantic text styles:

```swift
SpaceLargeDisplay("HYPER THRUST")
SpaceDisplay("HOST")
SpaceDisplay2("Raider MKII")
SpaceTitle("Mission Control")
SpaceTitle2("Subsystems")
SpaceSubtitle("Prepare for high speed chaos")
SpaceText("Hull integrity nominal")
SpaceCaption("SERVERS")
```

Modifier forms are available too:

```swift
Text("JOIN").spaceDisplay()
Text("Tap anywhere").spaceSubtitle(.orbitronMedium, color: .white)
Text("42").spaceTextStyle(26, font: .orbitronMedium)
```

Compatibility aliases remain available:

```swift
.orbitron_medium
.din_alternate // deprecated alias to Space Grotesk Regular
```

## Components

### Backgrounds

```swift
ContentView()
    .spaceBackground()

ContentView()
    .spaceAnimatedBackground()
```

`SpaceBackground` is the existing static game background. `SpaceAnimatedBackground` layers scrolling stars and fog over it.

### Buttons And Cards

```swift
SpaceCard(title: "Warp Drive", subtitle: "Nominal")
    .spaceUIStyle(.primary(role: .confirm))

SpaceButton("Launch") {
    launch()
}
.spaceUIStyle(.primary(role: .confirm, highlighted: true))

SpaceButtonTwoStep("Delete") {
    delete()
}
.spaceUIStyle(.primary(role: .destructive))

SpaceIconButton("xmark", accessibilityLabel: "Close") {
    close()
}
.spaceIconButtonStyle(.glass(role: .destructive))
```

### Chips

```swift
SpaceChip("AI", isOn: $aiEnabled, icon: "sparkles")
    .spaceUIStyle(.glass(role: .confirm))

SpaceChip(
    isOn: $serverPublic,
    onText: "PUBLIC",
    offText: "PRIVATE",
    onIcon: "antenna.radiowaves.left.and.right",
    offIcon: "lock"
)
.spaceChipStyle(.glass(role: .normal))
```

`SpaceChip` maps `isOn` to the style highlight state, so active chips get the highlighted outline/glow for the inherited or scoped role.

### Forms And Lists

```swift
SpaceTextField("Callsign", text: $callsign, placeholder: "Enter callsign")

SpaceSection("Servers") {
    SpaceListRow(title: "Yijue's iPad", status: "JOIN") {
        join()
    }
    .spaceUIStyle(.glass(role: .confirm))
}
```

`SpaceListRow` supports `selected` and `disabled` states for multiplayer-selector style rows:

```swift
SpaceListRow(
    title: "Server",
    status: "CONNECTING",
    selected: true,
    disabled: true
)
.spaceListRowStyle(.glass)
```

### Split View

```swift
@State private var focusedSide: SpaceSplitSide = .right

SpaceSplitView(focusedSide: $focusedSide, dimming: true) {
    hostControls
} rightContent: {
    joinControls
}
```

When `dimming` is `true`, tapping the unfocused side updates `focusedSide`. When `dimming` is `false`, only the developer-controlled binding changes focus.

### Pulse Text

```swift
SpacePulseText("Tap anywhere to begin")
```

## Roles

`SpaceUIRole` controls role colors for borders, glows, and status accents:

```swift
.normal
.confirm
.destructive
```

## Testing

```sh
CLANG_MODULE_CACHE_PATH=/private/tmp/spaceui_module_cache swift test --disable-sandbox
```

## License

SpaceUI is available under the AGPL-3.0 license. See [LICENSE](LICENSE) for details.
