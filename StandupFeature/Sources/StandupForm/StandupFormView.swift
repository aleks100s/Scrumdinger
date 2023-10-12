import SwiftUI
import ComposableArchitecture
import Extensions

public struct StandupFormView: View {
	let store: StoreOf<StandupFormFeature>
	@FocusState var focus: StandupFormFeature.State.Field?
	
	public init(store: StoreOf<StandupFormFeature>) {
		self.store = store
	}
	
	public var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Form {
				Section {
					TextField("Title", text: viewStore.$standup.title)
						.focused(self.$focus, equals: .title)
					HStack {
						Slider(value: viewStore.$standup.duration.minutes, in: 5...30, step: 1) {
							Text("Length")
						}
						Spacer()
						Text(viewStore.standup.duration.formatted(.units()))
					}
					ThemePicker(selection: viewStore.$standup.theme)
				} header: {
					Text("Standup Info")
				}
				Section {
					ForEach(viewStore.$standup.attendees) { $attendee in
						TextField("Name", text: $attendee.name)
							.focused(self.$focus, equals: .attendee(attendee.id))
					}
					.onDelete { indices in
						viewStore.send(.deleteAttendees(atOffsets: indices))
					}
					
					Button("Add attendee") {
						viewStore.send(.addAttendeeButtonTapped)
					}
				} header: {
					Text("Attendees")
				}
			}
			.bind(viewStore.$focus, to: self.$focus)
		}
	}
}

import Mock

#Preview {
	MainActor.assumeIsolated {
		NavigationStack {
			StandupFormView(store: Store(initialState: StandupFormFeature.State(standup: .mock), reducer: {
				StandupFormFeature()
			}))
		}
	}
}
