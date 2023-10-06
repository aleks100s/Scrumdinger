// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeechClient",
	platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpeechClient",
            targets: ["SpeechClient"]
		),
		.library(
			name: "SpeechClientImpl",
			targets: ["SpeechClientImpl"]
		)
    ],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", "1.2.0" ..< "2.0.0")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
		.target(name: "SpeechClient"),
        .target(
			name: "SpeechClientImpl",
			dependencies: [
				.byName(name: "SpeechClient"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
			]
		)
    ]
)