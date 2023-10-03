//
//  AppTests.swift
//  ScrumdingerTests
//
//  Created by Alexander on 29.09.2023.
//

import ComposableArchitecture
import XCTest
@testable import Scrumdinger

@MainActor
final class AppTests: XCTestCase {
	func testEdit() async {
		let standup = Standup.mock
		let store = TestStore(initialState: AppFeature.State(standupsListState: StandupsListFeature.State(standups: [standup]))) {
			AppFeature()
		}
		
		await store.send(.path(.push(id: 0, state: .detail(StandupDetailFeature.State(standup: standup))))) {
			$0.path[id: 0] = .detail(StandupDetailFeature.State(standup: standup))
		}
		
		await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped)))) {
			$0.path[id: 0, case: /AppFeature.Path.State.detail]?.destination = .editStandup(StandupFormFeature.State(standup: standup))
		}
		
		var editedStandup = standup
		editedStandup.title = "Test"
		
		await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editedStandup)))))))) {
			$0.path[id: 0, case: /AppFeature.Path.State.detail]?.$destination[case: /StandupDetailFeature.Destination.State.editStandup]?.standup.title = "Test"
		}
		
		await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped)))) {
			$0.path[id: 0, case: /AppFeature.Path.State.detail]?.destination = nil
			$0.path[id: 0, case: /AppFeature.Path.State.detail]?.standup.title = "Test"
		}
		
		await store.receive(.path(.element(id: 0, action: .detail(.delegate(.standupUpdate(editedStandup)))))) {
			$0.standupsListState.standups[0].title = "Test"
		}
	}
	
	func testEdit_NonExhaustive() async {
		let standup = Standup.mock
		let store = TestStore(initialState: AppFeature.State(standupsListState: StandupsListFeature.State(standups: [standup]))) {
			AppFeature()
		}
		store.exhaustivity = .off
		
		await store.send(.path(.push(id: 0, state: .detail(StandupDetailFeature.State(standup: standup)))))
		await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped))))
		
		var editedStandup = standup
		editedStandup.title = "Test"
		
		await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editedStandup))))))))
		await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped))))
		
		await store.receive(.path(.element(id: 0, action: .detail(.delegate(.standupUpdate(editedStandup)))))) {
			$0.standupsListState.standups[0].title = "Test"
		}
	}
	
	func testDeletion_NonExhaustive() async {
		let standup = Standup.mock
		let store = TestStore(
			initialState: AppFeature.State(
				path: StackState([.detail(StandupDetailFeature.State(standup: standup))]),
				standupsListState: StandupsListFeature.State(
					standups: [standup]
				)
			)
		) {
			AppFeature()
		}
		store.exhaustivity = .off
		
		await store.send(.path(.element(id: 0, action: .detail(.deleteButtonTapped))))
		await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.alert(.confirmDeletion)))))))
		await store.skipReceivedActions()
		store.assert {
			$0.path = StackState()
			$0.standupsListState.standups = []
		}
	}
	
	func testTimerRunOutEndMeeting() async {
		let standup = Standup(
			id: UUID(),
			attendees: [Attendee(id: UUID())],
			duration: .seconds(1),
			meetings: [],
			theme: .bubblegum,
			title: "Point-Free"
		)
		
		let store = TestStore(
			initialState: AppFeature.State(
				path: StackState([
					.detail(
						StandupDetailFeature.State(standup: standup)
					),
					.recordMeeting(
						RecordMeetingFeature.State(standup: standup)
					),
				]),
				standupsListState: StandupsListFeature.State(
					standups: [standup]
				)
			)
		) {
			AppFeature()
		}  withDependencies: {
			$0.continuousClock = ImmediateClock()
			$0.speechClient.requestAuthorization = { .denied }
			$0.date.now = Date(timeIntervalSince1970: 1234567890)
			$0.uuid = .incrementing
		}
		
		store.exhaustivity = .off
		
		await store.send(.path(.element(id: 1, action: .recordMeeting(.onTask))))
		await store.skipReceivedActions()
		
		store.assert {
			$0.path[id: 0, case: /AppFeature.Path.State.detail]?
				.standup.meetings = [
					Meeting(
						id: UUID(0),
						date: Date(timeIntervalSince1970: 1234567890),
						transcript: "N/A"
					)
				]
			XCTAssertEqual($0.path.count, 1)
		}
	}
	
	func testEndMeetingEarlyDiscard() async {
		let standup = Standup(
			id: UUID(),
			attendees: [Attendee(id: UUID())],
			duration: .seconds(1),
			meetings: [],
			theme: .bubblegum,
			title: "Point-Free"
		)
		
		let store = TestStore(
			initialState: AppFeature.State(
				path: StackState([
					.detail(
						StandupDetailFeature.State(standup: standup)
					),
					.recordMeeting(
						RecordMeetingFeature.State(standup: standup)
					),
				]),
				standupsListState: StandupsListFeature.State(
					standups: [standup]
				)
			)
		) {
			AppFeature()
		}  withDependencies: {
			$0.continuousClock = ImmediateClock()
			$0.speechClient.requestAuthorization = { .denied }
		}
		
		store.exhaustivity = .off
		
		await store.send(.path(.element(id: 1, action: .recordMeeting(.onTask))))
		await store.send(.path(.element(id: 1, action: .recordMeeting(.endMeetingButtonTapped))))
		await store.send(.path(.element(id: 1, action: .recordMeeting(.alert(.presented(.confirmDiscard))))))
		await store.skipReceivedActions()
		
		store.assert {
			$0.path[id: 0, case: /AppFeature.Path.State.detail]?.standup.meetings = []
			XCTAssertEqual($0.path.count, 1)
		}
	}
}
