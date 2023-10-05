import XCTest
import ComposableArchitecture
@testable import Scrumdinger

@MainActor
final class StandupsListTests: XCTestCase {
	func testAddStandup() async {
		let store = TestStore(initialState: StandupsListFeature.State()) {
			StandupsListFeature()
		} withDependencies: {
			$0.uuid = .incrementing
			$0.dataManager = .mock()
		}
		var standup = Standup(id: UUID(0), attendees: [Attendee(id: UUID(1))])
		await store.send(.addButtonTapped) {
			$0.addStandup = StandupFormFeature.State(standup: standup)
		}
		
		standup.title = "Test title"
		await store.send(.addStandup(.presented(.set(\.$standup, standup)))) {
			$0.addStandup?.standup.title = "Test title"
		}
		
		await store.send(.saveStandupButtonTapped) {
			$0.addStandup = nil
			$0.standups[0] = Standup(id: UUID(0), attendees: [Attendee(id: UUID(1))], title: "Test title")
		}
	}
	
	func testAddStandup_NonExauhstive() async {
		let store = TestStore(initialState: StandupsListFeature.State()) {
			StandupsListFeature()
		} withDependencies: {
			$0.uuid = .incrementing
			$0.dataManager = .mock()
		}
		store.exhaustivity = .off
		var standup = Standup(id: UUID(0), attendees: [Attendee(id: UUID(1))])
		await store.send(.addButtonTapped)
		standup.title = "Test title"
		await store.send(.addStandup(.presented(.set(\.$standup, standup))))
		
		await store.send(.saveStandupButtonTapped) {
			$0.standups[0] = Standup(id: UUID(0), attendees: [Attendee(id: UUID(1))], title: "Test title")
		}
	}
}
