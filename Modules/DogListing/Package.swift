// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DogListing",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DogListing",
            targets: ["DogListingCore"]),
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(path: "../SharedUtils")
    ],
    targets: [
        .target(
            name: "DogListingCore",
            dependencies: ["DogListingAPI"]
        ),
        .testTarget(
            name: "DogListingCoreTests",
            dependencies: [
                "DogListingCore",
                .product(name: "TestingUtils", package: "SharedUtils")
            ]
        ),
        
        .target(
            name: "DogListingAPI",
            dependencies: ["Networking"]
        ),
        .testTarget(
            name: "DogListingAPITests",
            dependencies: [
                "DogListingAPI",
                .product(name: "TestingUtils", package: "SharedUtils")
            ]
        ),
    ]
)
