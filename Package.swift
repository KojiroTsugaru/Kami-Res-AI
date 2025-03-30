// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "kami-res-ai",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_12)
    ],
    products: [
        .executable(name: "kami-res-ai", targets: ["kami-res-ai"])
    ],
    dependencies: [
        // Realm from master (adjust URL/branch/commit as needed)
        .package(
            url: "https://github.com/realm/realm-swift.git",
            branch: "master"
        ),
        // SuperwallKit at version 3.12.2
        .package(
            url: "https://github.com/superwall/Superwall-iOS.git",
            exact: "3.12.2"
        ),
        // SwiftfulLoadingIndicators at version 0.0.4
        .package(
            url: "https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators",
            exact: "0.0.4"
        )
    ],
    targets: [
        .executableTarget(
            name: "kami-res-ai",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "SuperwallKit", package: "Superwall-iOS"),
                .product(name: "SwiftfulLoadingIndicators", package: "SwiftfulLoadingIndicators")
            ],
            path: "kami-res-ai/App",
            swiftSettings: [
                // Force the compiler to use macOS 10.15 as the target for Swift concurrency features
                .unsafeFlags(["-target", "arm64-apple-macos10.15"])
            ]
        )
    ]
)
