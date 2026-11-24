// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ZoneBar",
    defaultLocalization: "zh-Hans",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "ZoneBar",
            path: "Sources/ZoneBar"
        )
    ]
)
