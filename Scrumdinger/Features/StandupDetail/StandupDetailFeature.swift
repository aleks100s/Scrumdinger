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
		@PresentationState  var editStandup: StandupFormFeature.State?
		@PresentationState var alert: AlertState<Action.Alert>?
		var standup: Standup
	}
	
	enum Action: Equatable {
		enum Delegate: Equatable {
			case standupUpdate(Standup)
		}
		
		enum Alert {
			case confirmDeletion
		}
		
		case alert(PresentationAction<Alert>)
		case editButtonTapped
		case deleteButtonTapped
		case deleteMeetings(IndexSet)
		case editStandup(PresentationAction<StandupFormFeature.Action>)
		case saveStandupButtonTapped
		case cancelStandupButtonTapped
		case delegate(Delegate)
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .alert(.presented(.confirmDeletion)):
				return .none
				
			case .alert(.dismiss):
				return .none
				
			case .editButtonTapped:
				state.editStandup = StandupFormFeature.State(standup: state.standup)
				return .none
				
			case .deleteButtonTapped:
				state.alert = AlertState(title: {
					TextState("Are you sure?")
				}, actions: {
					ButtonState(role: .destructive, action: .confirmDeletion) {
						TextState("Delete")
					}
				})
				return .none
				
			case let .deleteMeetings(indices):
				state.standup.meetings.remove(atOffsets: indices)
				return .none
				
			case .editStandup:
				return .none
				
			case .saveStandupButtonTapped:
				guard let standup = state.editStandup?.standup else { return .none }
				state.standup = standup
				state.editStandup = nil
				return .none
				
			case .cancelStandupButtonTapped:
				state.editStandup = nil
				return .none
				
			case .delegate:
				return .none
			}
		}
		.ifLet(\.$alert, action: /Action.alert)
		.ifLet(\.$editStandup, action: /Action.editStandup) {
			StandupFormFeature()
		}
		.onChange(of: \.standup) { oldValue, newValue in
			Reduce { state, action in
				.send(.delegate(.standupUpdate(newValue)))
			}
		}
	}
}
