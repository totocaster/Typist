// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Typist",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "Typist",
            targets: ["Typist"]),
    ],
    targets: [
        .target(
            name: "Typist",
            exclude: ["Typist-Demo"]),
    ],
    swiftLanguageVersions: [.v5]
)
