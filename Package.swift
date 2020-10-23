// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIViewController-DisplayChild",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "UIViewController-DisplayChild",
            targets: ["UIViewController-DisplayChild"]),
    ],
    targets: [
        .target(
            name: "UIViewController-DisplayChild",
            dependencies: [],
            path: "Sources"
        ),
    ]
)
