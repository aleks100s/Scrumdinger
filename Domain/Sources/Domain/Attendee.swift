import Foundation

public struct Attendee: Equatable, Identifiable, Codable {
	public let id: UUID
	public var name: String
	
	public init(id: UUID, name: String = "") {
		self.id = id
		self.name = name
	}
}
