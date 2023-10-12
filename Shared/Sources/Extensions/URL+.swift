import Foundation

public extension URL {
	static let standups = Self.documentsDirectory.appending(component: "standups.json")
}
