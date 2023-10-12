// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
	platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Shared",
            targets: [
				"DesignSystem",
				"Extensions"
			]
		),
    ],
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
			name: "DesignSystem",
			dependencies: ["Domain"]
		),
		.target(name: "Extensions")
    ]
)
