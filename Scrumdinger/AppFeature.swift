//
//  AppFeature.swift
//  Scrumdinger
//
//  Created by Alexander on 29.09.2023.
//

import Foundation
import ComposableArchitecture

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
		}
		
		enum Action: Equatable {
			case detail(StandupDetailFeature.Action)
			case recordMeeting(RecordMeetingFeature.Action)
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
				}
				return .none
				
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
	}
}
