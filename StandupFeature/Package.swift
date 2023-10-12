// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StandupFeature",
	platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "StandupFeature",
            targets: [
				"StandupForm",
				"StandupDetail",
				"StandupsList"
			]
		),
    ],
	dependencies: [
		.package(name: "Domain", path: "./Domain"),
		.package(name: "Shared", path: "./Shared"),
		.package(name: "DataManager", path: "./DataManager"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", "1.2.0" ..< "2.0.0")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "StandupForm",
			dependencies: [
				"Domain",
				"Shared",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
			]
		),
		.target(
			name: "StandupDetail",
			dependencies: [
				"Domain",
				"StandupForm",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
			]
		),
		.target(
			name: "StandupsList",
			dependencies: [
				"Domain",
				"Shared",
				"DataManager",
				"StandupForm",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
			]
		),
        .testTarget(
            name: "StandupFeatureTests",
            dependencies: [
				"StandupDetail",
				"StandupForm",
				"StandupsList",
				"Domain",
				"Shared",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
			]
		),
    ]
)
