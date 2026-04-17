# SpaceUI

A custom space / sci-fi UI component library for SwiftUI apps.

## Requirements

- iOS 17+ / macOS 14+ / tvOS 17+ / watchOS 10+
- Swift 5.9+

## Installation

Add SpaceUI to your project via Swift Package Manager:

```swift
.package(url: "https://github.com/Yinnotayl/SpaceUI", branch: "main")
```

Then add `"SpaceUI"` as a dependency to your target.

## Setup

> **Required:** You must register the space font before using any SpaceUI components. Call this once at app launch.
```swift
init() { SpaceFont.register() }
```

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

---

## Components

### `SpaceBackground`

A full-screen space background image that ignores safe area edges.

```swift
SpaceBackground()
```

#### `.spaceBackground(clipped:)` modifier

Applies the space background to any view. When `clipped` is `false` (default), the background wraps the view in a `ZStack`. When `true`, it applies as a clipped `.background()`.

```swift
ContentView()
    .spaceBackground()

// Clipped variant
SomeCard()
    .spaceBackground(clipped: true)
```

---

### `SpaceText`

A general-purpose text view using a space font.

```swift
SpaceText("Hello, Universe!")

// With custom font and size
SpaceText("Hello, Universe!", font: .orbitron_medium, size: .headline)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | — | The text to display |
| `font` | `SpaceFont` | `.orbitron_medium` | Font to use |
| `size` | `Font.TextStyle` | `.body` | Text style / size |

---

### `SpaceTitle`

A large title-sized text view styled for space UIs.

```swift
SpaceTitle("Mission Control")

// With custom font
SpaceTitle("Mission Control", font: .din_alternate)
```

---

### `SpaceTitle2`

A secondary title-sized text view (equivalent to `.title` style).

```swift
SpaceTitle2("Subsystem Status")

// With custom font
SpaceTitle2("Subsystem Status", font: .din_alternate)
```

---

### `SpaceSubtitle`

A subtitle text view. Defaults to `DIN Alternate` with reduced opacity and letter spacing.

```swift
SpaceSubtitle("Orbital velocity: 7.8 km/s")

// With custom font
SpaceSubtitle("Orbital velocity: 7.8 km/s", font: .orbitron_medium)
```

---

### `SpaceButton`

A tappable card-styled button supporting roles and highlight states.

```swift
SpaceButton(action: { print("Launched!") }) {
    Text("Launch")
}

// With role and highlight
SpaceButton(role: .confirm, highlighted: true, action: { confirm() }) {
    Text("Confirm Launch")
}
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `role` | `SpaceUIRole` | `.normal` | Visual role — `.normal`, `.confirm`, or `.destructive` |
| `highlighted` | `Bool` | `false` | Activates glowing animated border |
| `action` | `() -> Void` | — | Action to perform on tap |
| `label` | `@ViewBuilder` | — | Custom label view |

---

### `SpaceToggle`

A toggle built on `SpaceButton`. The button highlights when `isOn` is `true`.

```swift
@State private var enginesOn = false

SpaceToggle(isOn: $enginesOn) {
    Text("Engines")
}

// With string label shorthand
SpaceToggle("Shields", isOn: $shieldsOn, role: .confirm)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isOn` | `Binding<Bool>` | — | Binding to the toggle state |
| `role` | `SpaceUIRole` | `.normal` | Visual role |
| `highlighted` | `Bool?` | `nil` | Override highlight (defaults to `isOn`) |

---

### `SpaceButtonTwoStep`

A two-tap confirmation button. The first tap arms it (highlights it); the second tap fires the action. Useful for destructive or irreversible operations.

```swift
SpaceButtonTwoStep(
    role: .destructive,
    action: { deleteRecord() },
    confirmAction: { print("Armed — tap again to confirm") }
) {
    Text("Delete Record")
}
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `role` | `SpaceUIRole` | `.normal` | Visual role |
| `action` | `() -> Void` | — | Fired on the second (confirmed) tap |
| `confirmAction` | `() -> Void` | `{}` | Optional callback fired when armed on first tap |

---

### `SpaceTextField`

A space-styled text input field.

```swift
@State private var callsign = ""

// With title and placeholder
SpaceTextField("Callsign", text: $callsign, placeholder: "Enter callsign...")

// Without title
SpaceTextField(text: $callsign, placeholder: "Search...")

// With role
SpaceTextField("Target", text: $target, role: .destructive)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `titleKey` | `String?` | `nil` | Optional label above the field |
| `text` | `Binding<String>` | — | Bound text value |
| `placeholder` | `String` | `""` | Placeholder text |
| `role` | `SpaceUIRole` | `.normal` | Visual role |
| `highlighted` | `Bool?` | `nil` | Optional highlight override |

---

### `SpaceCard`

A container view with a dark frosted background, rounded corners, and an animated gradient border. Used internally by other components, but available for custom layouts.

```swift
SpaceCard {
    Text("Reactor Status: Online")
}

// Highlighted with role
SpaceCard(highlighted: true, role: .confirm) {
    VStack {
        Text("All Systems Go")
        Text("Ready for launch")
    }
}

// Convenience title/subtitle initialiser
SpaceCard(title: "Warp Drive", subtitle: "Nominal", role: .normal)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `highlighted` | `Bool` | `false` | Activates glowing animated border |
| `role` | `SpaceUIRole` | `.normal` | Controls border/shadow colour |
| `content` | `@ViewBuilder` | — | Content to display inside the card |

---

## View Modifiers

### `.spaceGlow(active:)`

Adds a cyan glow shadow effect to any view.

```swift
Image(systemName: "star.fill")
    .spaceGlow()

// Dimmed glow
Text("Standby")
    .spaceGlow(active: false)
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `active` | `Bool` | `true` | Full glow when `true`, dimmed when `false` |

---

## Fonts

SpaceUI includes two fonts available via the `SpaceFont` enum:

| Case | Font |
|---|---|
| `.orbitron_medium` | Orbitron Medium — angular, futuristic |
| `.din_alternate` | DIN Alternate — clean, technical |

You can also use them directly as `Font` extensions:

```swift
Text("Coordinates").font(.orbitron_medium(.title))
Text("42.3° N, 71.1° W").font(.din_alternate(.caption))
```

---

## `SpaceUIRole`

Controls the colour theme of interactive components.

| Role | Border / Shadow Colour | Typical Use |
|---|---|---|
| `.normal` | Teal / Cyan | Default actions |
| `.confirm` | Mint / Indigo | Positive / confirmation actions |
| `.destructive` | Red / Pink | Dangerous or irreversible actions |

---

## License

SpaceUI is available under the AGPL-3.0 license. See [LICENSE](LICENSE) for details.
