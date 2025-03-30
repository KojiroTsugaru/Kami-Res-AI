// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kami-res-ai",
    targets: [
        .executableTarget(
            name: "kami-res-ai",
            path: "kami-res-ai/App"
        ),
    ]
)
