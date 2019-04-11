// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Typist",
    // platforms: [.iOS("8.0")],
    products: [
        .library(name: "Typist", targets: ["Typist"])
    ],
    targets: [
        .target(
            name: "Typist",
            path: ".",
            exclude: ["Typist"],
            sources: ["Typist.swift"]
        )
    ]
)
