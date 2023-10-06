import Foundation
import DataManager
import ComposableArchitecture

extension DataManager: DependencyKey {
	public static let liveValue = Self(
		load: { try Data(contentsOf: $0) },
		save: { data, url in
			try data.write(to: url)
		}
	)
	
	public static let previewValue = mock()
	
	public static let failToRead = Self(
		load: { _ in
			Data()
		},
		save: { _, _ in
			struct SomeError: Error {}
			
			throw SomeError()
		}
	)
	
	public static let failToWrite = Self(
		load: { _ in
			struct SomeError: Error {}
			
			throw SomeError()
		},
		save: { _, _ in }
	)
	
	public static func mock(initialData: Data? = nil) -> Self {
		let data = LockIsolated(initialData)
		return Self(
			load: { _ in
				guard let data = data.value
				else {
					struct FileNotFound: Error {}
					throw FileNotFound()
				}
				return data
			},
			save: { newData, _ in data.setValue(newData) }
		)
	}
}

