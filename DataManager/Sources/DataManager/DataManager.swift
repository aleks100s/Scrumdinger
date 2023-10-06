import Foundation

public struct DataManager {
	public var load: @Sendable (URL) throws -> Data
	public var save: @Sendable (Data, URL) throws -> Void
	
	public init(
		load: @Sendable @escaping (URL) throws -> Data,
		save: @Sendable @escaping (Data, URL) throws -> Void
	) {
		self.load = load
		self.save = save
	}
}
