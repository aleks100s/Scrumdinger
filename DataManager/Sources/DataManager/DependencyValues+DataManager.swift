import ComposableArchitecture

public extension DependencyValues {
	var dataManager: DataManager {
		get { self[DataManager.self] }
		set { self[DataManager.self] = newValue }
	}
}
