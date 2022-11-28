// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalicoNetwork",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "NetworkClient",
            targets: ["NetworkClient"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4")
        ),
    ],
    targets: [
        .target(
            name: "NetworkClient",
            dependencies: [
                .product(
                    name: "Alamofire",
                    package: "Alamofire"
                )
            ]
        )
    ]
)
