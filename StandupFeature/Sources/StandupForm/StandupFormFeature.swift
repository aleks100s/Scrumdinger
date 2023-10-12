import ComposableArchitecture
import Foundation
import Domain

public struct StandupFormFeature: Reducer {
	public struct State: Equatable {
		public enum Field: Hashable {
			case attendee(Attendee.ID)
			case title
		}
		
		@BindingState public var standup: Standup
		@BindingState public var focus: Field?
		
		public init(standup: Standup, focus: Field? = .title) {
			self.standup = standup
			self.focus = focus
			if self.standup.attendees.isEmpty {
				@Dependency(\.uuid) var uuid
				self.standup.attendees.append(Attendee(id: uuid()))
			}
		}
	}
	
	public enum Action: BindableAction, Equatable {
		case addAttendeeButtonTapped
		case deleteAttendees(atOffsets: IndexSet)
		case binding(BindingAction<State>)
	}
	
	@Dependency(\.uuid) var uuid
	
	public var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .addAttendeeButtonTapped:
				let id = self.uuid()
				state.standup.attendees.append(Attendee(id: id))
				state.focus = .attendee(id)
				return .none
				
			case .binding(_):
				return .none
				
			case let .deleteAttendees(atOffsets: indices):
				state.standup.attendees.remove(atOffsets: indices)
				if state.standup.attendees.isEmpty {
					state.standup.attendees.append(Attendee(id: self.uuid()))
				}
				guard let firstIndex = indices.first else { return .none }
				
				let index = min(firstIndex, state.standup.attendees.count - 1)
				state.focus = .attendee(state.standup.attendees[index].id)
				return .none
			}
		}
	}
	
	public init() {}
}
