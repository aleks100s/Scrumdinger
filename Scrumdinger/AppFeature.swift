import Foundation
import ComposableArchitecture
import Domain
import DataManagerImpl
import RecordMeeting

struct AppFeature: Reducer {
	struct State: Equatable {
		var path = StackState<Path.State>()
		var standupsListState = StandupsListFeature.State()
	}
	
	enum Action: Equatable {
		case path(StackAction<Path.State, Path.Action>)
		case standupsList(StandupsListFeature.Action)
	}
	
	struct Path: Reducer {
		enum State: Equatable {
			case detail(StandupDetailFeature.State)
			case recordMeeting(RecordMeetingFeature.State)
			case meeting(Meeting, standup: Standup)
		}
		
		enum Action: Equatable {
			case detail(StandupDetailFeature.Action)
			case recordMeeting(RecordMeetingFeature.Action)
			case meeting(Never)
		}
		
		var body: some ReducerOf<Self> {
			Scope(state: /State.detail, action: /Action.detail) {
				StandupDetailFeature()
			}
			Scope(state: /State.recordMeeting, action: /Action.recordMeeting) {
				RecordMeetingFeature()
			}
		}
	}
	
	@Dependency(\.uuid) var uuid
	@Dependency(\.date.now) var date
	@Dependency(\.continuousClock) var clock
	@Dependency(\.dataManager.save) var saveData
	
	var body: some ReducerOf<Self> {
		Scope(state: \.standupsListState, action: /Action.standupsList) {
			StandupsListFeature()
		}
		
		Reduce { state, action in
			switch action {
			case let .path(.element(id: _ , action: .detail(.delegate(action)))):
				switch action {
				case let .standupUpdate(standup):
					state.standupsListState.standups[id: standup.id] = standup
					
				case let .deleteStandup(id: id):
					state.standupsListState.standups.remove(id: id)
					
				case let .recordMeeting(standup):
					state.path.append(.recordMeeting(RecordMeetingFeature.State(standup: standup)))
					
				case let .showMeeting(meeting, standup: standup):
					state.path.append(.meeting(meeting, standup: standup))
				}
				return .none
				
			case let .path(.element(id: id, action: .recordMeeting(.delegate(action)))):
				switch action {
				case let .saveMeeting(transcript):
					guard let detailID = state.path.ids.dropLast().last else {
						XCTFail("Record meeting is the last in the stack. A detail feature should proceed it.")
						return .none
					}
					
					let meeting = Meeting(id: uuid(), date: date, transcript: transcript)
					state.path[id: detailID, case: /Path.State.detail]?.standup.meetings.insert(meeting, at: 0)
					
					guard let standup = state.path[id: detailID, case: /Path.State.detail]?.standup else { return .none }
					state.standupsListState.standups[id: standup.id] = standup
					return .none
				}
				
			case let .standupsList(listAction):
				switch listAction {
				case let .standupCardTapped(standup):
					state.path.append(.detail(StandupDetailFeature.State(standup: standup)))
					
				default:
					break
				}
				return .none
								
			default:
				return .none
			}
		}
		.forEach(\.path, action: /Action.path) {
			Path()
		}
		
		Reduce { state, _ in
				.run { [standups = state.standupsListState.standups] _ in
				enum CancelID {
					case saveDebounce
				}
				
				try await withTaskCancellation(id: CancelID.saveDebounce, cancelInFlight: true) {
					try await self.clock.sleep(for: .seconds(1))
					try self.saveData(JSONEncoder().encode(standups), .standups)
					
				}
			}
		}
	}
}
