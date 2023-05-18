// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenCastKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "OpenCastKit",
            targets: ["OpenCastKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.21.0")
    ],
    targets: [
        .target(
            name: "OpenCastKit",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ]),
        .testTarget(
            name: "OpenCastKitTests",
            dependencies: ["OpenCastKit"]),
    ]
)
