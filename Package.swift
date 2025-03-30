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
        
        // If you have a separate "RealmDatabase" package at version 14.14.0
        .package(
            url: "https://github.com/YourOrg/RealmDatabase.git",
            exact: "14.14.0"
        ),
        
        // Superscript at version 0.1.16
        .package(
            url: "https://github.com/YourOrg/Superscript.git",
            exact: "0.1.16"
        ),
        
        // SuperwallKit at version 3.12.2
        // (Update URL if different; this is the current known SuperwallKit repo)
        .package(
            url: "https://github.com/superwall-me/superwall-ios-sdk.git",
            exact: "3.12.2"
        ),
        
        // SwiftfulLoadingIndicators at version 0.0.4
        .package(
            url: "https://github.com/YourOrg/SwiftfulLoadingIndicators.git",
            exact: "0.0.4"
        )
    ],
    targets: [
        .executableTarget(
            name: "kami-res-ai",
            dependencies: [
                // Update product names to match each package’s product definition:
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "RealmDatabase", package: "RealmDatabase"),
                .product(name: "Superscript", package: "Superscript"),
                .product(name: "SuperwallKit", package: "superwall-ios-sdk"),
                .product(name: "SwiftfulLoadingIndicators", package: "SwiftfulLoadingIndicators")
            ],
            path: "kami-res-ai/App"
        )
    ]
)
