// swift-interface-format-version: 1.0
import PackageDescription

let package = Package(
    name: "AutoVidSDK",
    platforms: [.iOS(.v15), .macOS(.v12)], // XCUITest hem iOS hem macOS destekler
    products: [
        .library(name: "AutoVidSDK", targets: ["AutoVidSDK"]),
    ],
    targets: [
        .target(
            name: "AutoVidSDK",
            dependencies: [],
            path: "Sources/AutoVidSDK",
            linkerSettings: [.linkedFramework("XCTest")] // XCTest framework'ünü bağlar
        )
    ]
)