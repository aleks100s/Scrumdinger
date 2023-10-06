import DataManager
import DataManagerImpl
import ComposableArchitecture

extension DependencyValues {
	var dataManager: DataManager {
		get { self[DataManager.self] }
		set { self[DataManager.self] = newValue }
	}
}
