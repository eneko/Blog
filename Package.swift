// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Blog",
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", from: "0.3.0"),
        .package(url: "https://github.com/eneko/GitHub", from: "0.1.0")
    ],
    targets: [
        .target(name: "IssueProcessorLambda", dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
        ]),
        .target(name: "Blog", dependencies: []),
        .testTarget(name: "BlogTests", dependencies: ["Blog"]),
    ]
)
