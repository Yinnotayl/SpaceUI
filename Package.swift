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
            path: "Sources/SpaceUI",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SpaceUITests",
            dependencies: ["SpaceUI"],
            path: "Tests/SpaceUITests"
        )
    ]
)
