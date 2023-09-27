import ComposableArchitecture
import Foundation

struct StandupsListFeature: Reducer {
	struct State: Equatable {
		@PresentationState var addStandup: StandupFormFeature.State?
		var standups: IdentifiedArrayOf<Standup> = []
	}
	
	enum Action {
		case addButtonTapped
		case addStandup(PresentationAction<StandupFormFeature.Action>)
		case cancelStandupButtonTapped
		case saveStandupButtonTapped
	}
	
	@Dependency(\.uuid) var uuid
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.addStandup = StandupFormFeature.State(standup: Standup(id: self.uuid()))
				return .none
				
			case .addStandup:
				return .none
				
			case .cancelStandupButtonTapped:
				state.addStandup = nil
				return .none
				
			case .saveStandupButtonTapped:
				guard let standup = state.addStandup?.standup else { return .none }
				
				state.standups.append(standup)
				state.addStandup = nil
				return .none
			}
		}
		.ifLet(\.$addStandup, action: /Action.addStandup) {
			StandupFormFeature()
		}
	}
}
