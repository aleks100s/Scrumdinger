import ComposableArchitecture
import SwiftUI

struct StandupFormFeature: Reducer {
	struct State: Equatable {
		enum Field: Hashable {
			case attendee(Attendee.ID)
			case title
		}
		
		@BindingState var standup: Standup
		@BindingState var focus: Field?
		
		init(standup: Standup, focus: Field? = .title) {
			self.standup = standup
			self.focus = focus
			if self.standup.attendees.isEmpty {
				self.standup.attendees.append(Attendee(id: UUID()))
			}
		}
	}
	
	enum Action: BindableAction {
		case addAttendeeButtonTapped
		case deleteAttendees(atOffsets: IndexSet)
		case binding(BindingAction<State>)
	}
	
	@Dependency(\.uuid) var uuid
	
	var body: some ReducerOf<Self> {
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
}
