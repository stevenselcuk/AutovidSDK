import PackageDescription

let package = Package(
    name: "AutoVidSDK",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "AutoVidSDK", targets: ["AutoVidSDK"]),
    ],
    targets: [
        .target(
            name: "AutoVidSDK",
            dependencies: [],
            path: "Sources/AutoVidSDK",
            linkerSettings: [.linkedFramework("XCTest")]
        )
    ]
)