// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BaseKit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "BaseKit",
            targets: ["BaseKit"]
        ),
    ],
    targets: [
        .target(
            name: "BaseKit"
        ),
        .testTarget(
            name: "BaseKitTests",
            dependencies: ["BaseKit"]
        ),
    ]
)
