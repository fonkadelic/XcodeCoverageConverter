// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "XcodeCoverageConverter",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "xcc", targets: ["xcc"]),
        .plugin(name: "XcodeCoverageConverterPlugin", targets: ["XcodeCoverageConverterPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.6")
    ],
    targets: [
        .plugin(
          name: "XcodeCoverageConverterPlugin",
          capability: .command(
            intent: .custom(
              verb: "xcc",
              description: "Convert Xcode generated code coverage data into CI friendly formats"
            )
          ),
          dependencies: [
              .target(name: "xcc")
//            .target(name: "SwiftLintBinary", condition: .when(platforms: [.macOS])),
//            .target(name: "swiftlint", condition: .when(platforms: [.linux]))
          ]
        ),
        .executableTarget(
            name: "xcc",
            dependencies: ["Core", "ResourcesEmbedded"]
        ),
        .target(
            name: "Core",
            dependencies: [
                .target(name: "Resources"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/Core"
        ),
        // Resources
        .target(
            name: "Resources",
            path: "Sources/Resources/Main"
        ),
        .target(
            name: "ResourcesBundled",
            path: "Sources/Resources/Bundled",
            resources: [.copy("coverage-04.dtd")]
        ),
        .target(
            name: "ResourcesEmbedded",
            path: "Sources/Resources/Embedded",
            publicHeadersPath: ".",
            linkerSettings: [.unsafeFlags(
                ["-Xlinker", "-sectcreate",
                 "-Xlinker", "__DATA",
                 "-Xlinker", "__coverage_dtd",
                 "-Xlinker", "Sources/Resources/Bundled/coverage-04.dtd"]
                // verify if the file is embedded by running
                // `otool -X -s __DATA __coverage_dtd <path/to/xcc> | xxd -rma`
            )]
        ),
        // Tests
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core", "ResourcesBundled"],
            path: "Tests/CoreTests"
        )
    ]
)
