// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-ascii",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "ASCII", targets: ["ASCII"]),
        .library(name: "ASCII Standard Library Integration", targets: ["ASCII Standard Library Integration"]),
        .library(name: "ASCII Foundation Library Integration", targets: ["ASCII Foundation Library Integration"]),
        .library(name: "ASCII Test Support", targets: ["ASCII Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "ASCII",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
            ],
            path: "Sources/ASCII"
        ),
        .target(
            name: "ASCII Standard Library Integration",
            dependencies: [
                .target(name: "ASCII"),
            ],
            path: "Sources/ASCII Standard Library Integration"
        ),
        .target(
            name: "ASCII Foundation Library Integration",
            dependencies: [
                .target(name: "ASCII"),
                .target(name: "ASCII Standard Library Integration"),
            ],
            path: "Sources/ASCII Foundation Library Integration"
        ),
        .target(
            name: "ASCII Test Support",
            dependencies: [
                .target(name: "ASCII"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "ASCII Tests",
            dependencies: [
                .target(name: "ASCII"),
                .product(name: "Byte", package: "swift-byte"),
                .target(name: "ASCII Test Support"),
                .target(name: "ASCII Standard Library Integration"),
                .target(name: "ASCII Foundation Library Integration"),
            ],
            path: "Tests/ASCII Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
