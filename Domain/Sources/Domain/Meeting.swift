import Foundation

public struct Meeting: Equatable, Identifiable, Codable {
	public let id: UUID
	public let date: Date
	public var transcript: String
	
	public init(id: UUID, date: Date, transcript: String) {
		self.id = id
		self.date = date
		self.transcript = transcript
	}
}
