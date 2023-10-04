//
//  StandupDetailFeature.swift
//  Scrumdinger
//
//  Created by Alexander on 27.09.2023.
//

import Foundation
import ComposableArchitecture

struct StandupDetailFeature: Reducer {
	struct State: Equatable {
		@PresentationState var destination: Destination.State?
		var standup: Standup
	}
	
	enum Action: Equatable {
		enum Delegate: Equatable {
			case standupUpdate(Standup)
			case deleteStandup(id: Standup.ID)
			case recordMeeting(Standup)
			case showMeeting(Meeting, standup: Standup)
		}
		
		enum Alert {
			case confirmDeletion
		}
		
		case editButtonTapped
		case deleteButtonTapped
		case deleteMeetings(IndexSet)
		case saveStandupButtonTapped
		case cancelStandupButtonTapped
		case delegate(Delegate)
		case destination(PresentationAction<Destination.Action>)
		case meetingTapped(Meeting)
	}
	
	struct Destination: Reducer {
		enum State: Equatable {
			case alert(AlertState<Action.Alert>)
			case editStandup(StandupFormFeature.State)
		}
		
		enum Action: Equatable {
			enum Alert {
				case confirmDeletion
			}
			case alert(Alert)
			case editStandup(StandupFormFeature.Action)
		}
		
		var body: some ReducerOf<Self> {
			Scope(state: /State.editStandup, action: /Action.editStandup) {
				StandupFormFeature()
			}
		}
	}
	
	@Dependency(\.dismiss) var dismiss
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .destination(.presented(.alert(.confirmDeletion))):
				return .run { [id = state.standup.id] send in
					await send(.delegate(.deleteStandup(id: id)))
					await self.dismiss()
				}
				
			case .destination:
				return .none
				
			case .editButtonTapped:
				state.destination = .editStandup(StandupFormFeature.State(standup: state.standup))
				return .none
				
			case .deleteButtonTapped:
				state.destination = .alert(
					AlertState(title: {
						TextState("Are you sure?")
					}, actions: {
						ButtonState(role: .destructive, action: .confirmDeletion) {
							TextState("Delete")
						}
					})
				)
				return .none
				
			case let .deleteMeetings(indices):
				state.standup.meetings.remove(atOffsets: indices)
				return .none
				
			case .saveStandupButtonTapped:
				guard case let .editStandup(standupForm) = state.destination else { return .none }
				state.standup = standupForm.standup
				state.destination = nil
				return .none
				
			case .cancelStandupButtonTapped:
				state.destination = nil
				return .none
				
			case .delegate:
				return .none
				
			case let .meetingTapped(meeting):
				return .run { [standup = state.standup] send in
					await send(.delegate(.showMeeting(meeting, standup: standup)))
				}
			}
		}
		.ifLet(\.$destination, action: /Action.destination) {
			Destination()
		}
		.onChange(of: \.standup) { oldValue, newValue in
			Reduce { state, action in
				.send(.delegate(.standupUpdate(newValue)))
			}
		}
	}
}
