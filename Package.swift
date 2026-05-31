// swift-tools-version: 5.9

import PackageDescription

let package: Package = Package(
    name: "SpaceUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "SpaceUI",
            targets: ["SpaceUI"]
        )
    ],
    targets: [
        .target(
            name: "SpaceUI",
            dependencies: [],
            path: "Sources/SpaceUI",
            resources: [
                .process("Resources/Orbitron-Regular.ttf"),
                .process("Resources/Orbitron-Medium.ttf"),
                .process("Resources/Orbitron-SemiBold.ttf"),
                .process("Resources/Orbitron-Bold.ttf"),
                .process("Resources/Orbitron-ExtraBold.ttf"),
                .process("Resources/Orbitron-Black.ttf"),
                .process("Resources/SpaceGrotesk-Light.ttf"),
                .process("Resources/SpaceGrotesk-Regular.ttf"),
                .process("Resources/SpaceGrotesk-Medium.ttf"),
                .process("Resources/SpaceGrotesk-SemiBold.ttf"),
                .process("Resources/SpaceGrotesk-Bold.ttf"),
                .process("Resources/Orbitron-OFL.txt"),
                .process("Resources/SpaceGrotesk-OFL.txt"),
                .process("Resources/Assets.xcassets"),
            ]
        ),
        .testTarget(
            name: "SpaceUITests",
            dependencies: ["SpaceUI"],
            path: "Tests/SpaceUITests"
        )
    ]
)
