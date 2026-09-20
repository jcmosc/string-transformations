// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "string-transformation",
    products: [
        .library(
            name: "string-transformation",
            targets: ["StringTransformation"]
        )
    ],
    targets: [
        .target(
            name: "StringTransformation",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ],
        ),
        .testTarget(
            name: "StringTransformationTests",
            dependencies: ["StringTransformation"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ],
        ),
    ]
)
