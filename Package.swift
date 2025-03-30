// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "kami-res-ai",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "kami-res-ai", targets: ["kami-res-ai"])
    ],
    dependencies: [
        // Realm from master (adjust URL/branch/commit as needed)
        .package(
            url: "https://github.com/realm/realm-swift.git",
            .branch("master")
        ),    
        // SuperwallKit at version 3.12.2
        // (Update URL if different; this is the current known SuperwallKit repo)
        .package(
            url: "https://github.com/superwall-me/superwall-ios-sdk.git",
            from: "3.0.0"
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
                // Update product names to match each package’s product definition:
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "SuperwallKit", package: "superwall-ios-sdk"),
                .product(name: "SwiftfulLoadingIndicators", package: "SwiftfulLoadingIndicators")
            ],
            path: "kami-res-ai/App"
        )
    ]
)
