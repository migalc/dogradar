// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedUtils",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SharedUtils",
            targets: ["SharedUtils"]),
        .library(
            name: "TestingUtils",
            targets: ["TestingUtils"]),
    ],
    targets: [
        .target(
            name: "SharedUtils"),
        .testTarget(
            name: "SharedUtilsTests",
            dependencies: ["SharedUtils"]
        ),

        .target(
            name: "TestingUtils")
    ]
)
