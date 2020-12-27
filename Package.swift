// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Blog",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "socialpreview", targets: ["SocialPreviewGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", from: "0.3.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
//        .package(url: "https://github.com/eneko/GitHub", from: "0.1.0")
        .package(url: "https://github.com/eneko/DateTemplates", from: "0.1.0"),
    ],
    targets: [
        .target(name: "IssueProcessorLambda", dependencies: [
            "Blog",
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
        ]),
        .target(name: "Blog", dependencies: [
            .product(name: "Logging", package: "swift-log"),
        ]),
        .target(name: "SocialPreviewGenerator", dependencies: [
            "DateTemplates",
        ]),
        .testTarget(name: "BlogTests", dependencies: ["Blog"]),
    ]
)
