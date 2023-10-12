import ComposableArchitecture
import Foundation
import Domain
import Extensions
import StandupForm
import DataManager

public struct StandupsListFeature: Reducer {
	public struct State: Equatable {
		@PresentationState public var addStandup: StandupFormFeature.State?
		public var standups: IdentifiedArrayOf<Standup> = []
		
		public init(addStandup: StandupFormFeature.State? = nil) {
			@Dependency(\.dataManager.load) var loadData
			
			self.addStandup = addStandup
			do {
				self.standups = try JSONDecoder().decode(IdentifiedArrayOf<Standup>.self, from: loadData(.standups))
			} catch {
				self.standups = []
			}
		}
	}
	
	public enum Action: Equatable {
		case addButtonTapped
		case addStandup(PresentationAction<StandupFormFeature.Action>)
		case cancelStandupButtonTapped
		case saveStandupButtonTapped
		case standupCardTapped(Standup)
	}
	
	@Dependency(\.uuid) var uuid
	
	public var body: some ReducerOf<Self> {
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
				
			case .standupCardTapped:
				return .none
			}
		}
		.ifLet(\.$addStandup, action: /Action.addStandup) {
			StandupFormFeature()
		}
	}
	
	public init() {}
}
