// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "discord-bot-swift",
    dependencies: [
        .package(url: "https://github.com/Azoy/Sword", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "discord-bot-swift",
            dependencies: ["Sword"]),
        .testTarget(
            name: "discord-bot-swiftTests",
            dependencies: ["discord-bot-swift"]),
    ]
)
