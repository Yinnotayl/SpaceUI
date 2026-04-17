// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "spaceui",
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
                .process("Resources/Orbitron-Medium.ttf"),
                .copy("Resources/SpaceBackground.png")
            ]
        )
    ]
)
