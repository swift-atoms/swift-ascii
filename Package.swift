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
        .library(name: "ASCII Foundation Integration", targets: ["ASCII Foundation Integration"]),
        .library(name: "ASCII Test Support", targets: ["ASCII Test Support"]),
        .library(name: "ASCII Parser Test Support", targets: ["ASCII Parser Test Support"]),
        .library(name: "ASCII Serializer Test Support", targets: ["ASCII Serializer Test Support"]),
    ],
    traits: [
        .trait(name: "Coder", description: "Absorbed Coder integration", enabledTraits: ["Parser"]),
        .trait(name: "Parser", description: "Absorbed Parser integration"),
        .trait(name: "Serializer", description: "Absorbed Serializer integration"),
    ],
    dependencies: [

        .package(url: "https://github.com/swift-atoms/swift-carrier.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-binary.git", branch: "main", traits: [.trait(name: "Serializer", condition: .when(traits: ["Serializer"]))]),
        .package(url: "https://github.com/swift-atoms/swift-checkpoint.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-coder.git", branch: "main", traits: [
            .trait(name: "Carrier", condition: .when(traits: ["Coder"])),
            .trait(name: "Map", condition: .when(traits: ["Coder"])),
        ]),
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-either.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-iterator.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-map.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-parser.git", branch: "main", traits: [
            .trait(name: "Map", condition: .when(traits: ["Parser", "Coder"])),
            .trait(name: "IteratorLeaves", condition: .when(traits: ["Parser", "Coder"])),
            .trait(name: "Product", condition: .when(traits: ["Parser", "Coder"])),
            .trait(name: "Skip", condition: .when(traits: ["Parser", "Coder"])),
            .trait(name: "Append", condition: .when(traits: ["Parser", "Coder"])),
            .trait(name: "Either", condition: .when(traits: ["Parser", "Coder"])),
            .trait(name: "Iterator", condition: .when(traits: ["Parser", "Coder"])),
        ]),
        .package(url: "https://github.com/swift-atoms/swift-serializer.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "ASCII",
            dependencies: [
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Checkpoint", package: "swift-checkpoint"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Cursor", package: "swift-cursor"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Serializer", package: "swift-serializer"),
            ],
            path: "Sources/ASCII"
        ),

        .target(
            name: "ASCII Foundation Integration",
            dependencies: [
                .target(name: "ASCII"),
            ],
            path: "Sources/ASCII Foundation Integration"
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
                .target(name: "ASCII Foundation Integration"),
            ],
            path: "Tests/ASCII Tests"
        ),
        .testTarget(
            name: "Consolidated ASCII Carrier Tests",
            dependencies: [
.target(name: "ASCII"), .product(name: "Carrier", package: "swift-carrier")],
            path: "Tests/Consolidated swift-ascii-carrier"
        ),
        .testTarget(name: "Absorbed swift-ascii-parser ASCII Binary Parser Tests", dependencies: [.target(name: "ASCII"), .target(name: "ASCII Parser Test Support"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/ASCII Binary Parser Tests"),
        .testTarget(name: "Absorbed swift-ascii-parser ASCII Decimal Parser Tests", dependencies: [.target(name: "ASCII"), .target(name: "ASCII Parser Test Support"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/ASCII Decimal Parser Tests"),
        .testTarget(name: "Absorbed swift-ascii-parser ASCII Hexadecimal Parser Tests", dependencies: [.target(name: "ASCII"), .target(name: "ASCII Parser Test Support"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/ASCII Hexadecimal Parser Tests"),
        .testTarget(name: "Absorbed swift-ascii-parser ASCII Octal Parser Tests", dependencies: [.target(name: "ASCII"), .target(name: "ASCII Parser Test Support"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/ASCII Octal Parser Tests"),
        .testTarget(name: "Absorbed swift-ascii-parser ASCII Parser Standard Library Integration Tests", dependencies: [.target(name: "ASCII"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/ASCII Parser Standard Library Integration Tests"),
        .testTarget(name: "Absorbed swift-ascii-parser Declarative Parser Syntax Tests", dependencies: [.target(name: "ASCII"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Either", package: "swift-either", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Parser", package: "swift-parser", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/Declarative Parser Syntax Tests"),
        .target(name: "ASCII Parser Test Support", dependencies: [.target(name: "ASCII"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Parser", "Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Parser", "Coder"]))], path: "Tests/Absorbed/swift-ascii-parser/Support"),
        .testTarget(name: "Absorbed swift-ascii-serializer ASCII Binary Serializer Tests", dependencies: [.target(name: "ASCII"), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Serializer"]))], path: "Tests/Absorbed/swift-ascii-serializer/ASCII Binary Serializer Tests"),
        .testTarget(name: "Absorbed swift-ascii-serializer ASCII Decimal Serializer Tests", dependencies: [.target(name: "ASCII"), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Serializer"]))], path: "Tests/Absorbed/swift-ascii-serializer/ASCII Decimal Serializer Tests"),
        .testTarget(name: "Absorbed swift-ascii-serializer ASCII Hexadecimal Serializer Tests", dependencies: [.target(name: "ASCII"), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Serializer"]))], path: "Tests/Absorbed/swift-ascii-serializer/ASCII Hexadecimal Serializer Tests"),
        .testTarget(name: "Absorbed swift-ascii-serializer ASCII Octal Serializer Tests", dependencies: [.target(name: "ASCII"), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Serializer"]))], path: "Tests/Absorbed/swift-ascii-serializer/ASCII Octal Serializer Tests"),
        .testTarget(name: "Absorbed swift-ascii-serializer Serializable ASCII Tests", dependencies: [.target(name: "ASCII"), .product(name: "Binary", package: "swift-binary", condition: .when(traits: ["Serializer"])), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Serializer"]))], path: "Tests/Absorbed/swift-ascii-serializer/Serializable ASCII Tests"),
        .target(name: "ASCII Serializer Test Support", dependencies: [.target(name: "ASCII")], path: "Tests/Absorbed/swift-ascii-serializer/Support"),
        .testTarget(name: "Absorbed swift-ascii-coder ASCII Decimal Coder Tests", dependencies: [.target(name: "ASCII"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Coder"])), .product(name: "Coder", package: "swift-coder", condition: .when(traits: ["Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Coder"])), .product(name: "Parser", package: "swift-parser", condition: .when(traits: ["Coder"])), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Coder"]))], path: "Tests/Absorbed/swift-ascii-coder/ASCII Decimal Coder Tests"),
        .testTarget(name: "Absorbed swift-carrier-coder Carrier Coder Tests", dependencies: [.target(name: "ASCII"), .product(name: "Byte", package: "swift-byte", condition: .when(traits: ["Coder"])), .product(name: "Carrier", package: "swift-carrier", condition: .when(traits: ["Coder"])), .product(name: "Coder", package: "swift-coder", condition: .when(traits: ["Coder"])), .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Coder"])), .product(name: "Map", package: "swift-map", condition: .when(traits: ["Coder"])), .product(name: "Parser", package: "swift-parser", condition: .when(traits: ["Coder"])), .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Coder"])), .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Coder"]))], path: "Tests/Absorbed/swift-carrier-coder/Carrier Coder Tests"),
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
