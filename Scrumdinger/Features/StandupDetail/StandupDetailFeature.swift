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
		var standup: Standup
	}
	
	enum Action {
		case editButtonTapped
		case deleteButtonTapped
		case deleteMeetings(IndexSet)
		case editStandup(PresentationAction<StandupFormFeature.Action>)
		case saveStandupButtonTapped
		case cancelStandupButtonTapped
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .editButtonTapped:
				state.editStandup = StandupFormFeature.State(standup: state.standup)
				return .none
				
			case .deleteButtonTapped:
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
			}
		}
		.ifLet(\.$editStandup, action: /Action.editStandup) {
			StandupFormFeature()
		}
	}
}
