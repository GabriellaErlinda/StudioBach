// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BachStudioCore",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Services", targets: ["Services"])
    ],
    targets: [
        .target(name: "Models"),
        .target(name: "Services", dependencies: ["Models"])
    ]
)
