// swift-tools-version: 5.9
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
        .library(
            name: "ListFeature",
            targets: ["ListFeature", "DogListingCore"]),
        .library(
            name: "DetailFeature",
            targets: ["DetailFeature", "DogListingCore"]),
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(path: "../SharedUtils"),
        .package(path: "../UIComponents")
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

        // MARK: - Features
        
        .target(
            name: "ListFeature",
            dependencies: [
                "DogListingCore",
                "DetailFeature",
                "UIComponents"
            ]
        ),
        .testTarget(
            name: "ListFeatureTests",
            dependencies: [
                "ListFeature",
                .product(name: "TestingUtils", package: "SharedUtils")
            ]
        ),
        
        .target(
            name: "DetailFeature",
            dependencies: [
                "DogListingCore",
                "UIComponents"
            ]
        ),
        .testTarget(
            name: "DetailFeatureTests",
            dependencies: [
                "DetailFeature",
                .product(name: "TestingUtils", package: "SharedUtils")
            ]
        ),
    ]
)
