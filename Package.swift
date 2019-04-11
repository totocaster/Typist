// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Typist",
    platforms: [
        // .iOS(.v8),
    ],
    products: [
        .library(
            name: "Typist",
            targets: ["Typist"]),
    ],
    targets: [
        .target(
            name: "Typist",
            path: ".",
            exclude: ["Typist"],
            sources: ["Typist.swift"]),
    ],
    swiftLanguageVersions: [.v5]
)