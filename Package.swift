// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dojo-ios-sdk-drop-in-ui",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "dojo-ios-sdk-drop-in-ui",
            targets: ["dojo-ios-sdk-drop-in-ui"]),
    ],
    dependencies: [
        // Dojo libs
        .package(url: "git@github.com:dojo-engineering/dojo-ios-sdk", from: "1.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "dojo-ios-sdk-drop-in-ui",
            dependencies: [
                .product(name: "dojo-ios-sdk", package: "dojo-ios-sdk"),
            ],
            path: "Sources/dojo-ios-sdk-drop-in-ui/Classes",
            resources: [
                .process("Assets/Fonts"), .process("Assets/Other")],
            swiftSettings: [
                .define("SPM")
            ]
        )
    ]
)
