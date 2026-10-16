// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "string-transformations",
    products: [
        .library(
            name: "StringTransformations",
            targets: ["StringTransformations"]
        )
    ],
    targets: [
        .target(
            name: "StringTransformations",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ],
        ),
        .testTarget(
            name: "StringTransformationsTests",
            dependencies: ["StringTransformations"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ],
        ),
    ]
)
