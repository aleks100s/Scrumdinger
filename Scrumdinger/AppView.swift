import SwiftUI
import ComposableArchitecture
import Meeting
import RecordMeeting

struct AppView: View {
	let store: StoreOf<AppFeature>
	
    var body: some View {
		NavigationStackStore(
			self.store.scope(
				state: \.path,
				action: { .path($0) }
			),
			root: {
				StandupListView(
					store: self.store.scope(
						state: \.standupsListState,
						action: { .standupsList($0) }
					)
				)
			},
			destination: { state in
				switch state {
				case .detail:
					CaseLet(
						/AppFeature.Path.State.detail,
						 action: AppFeature.Path.Action.detail,
						 then: StandupDetailView.init(store:)
					)
					
				case .recordMeeting:
					CaseLet(
						/AppFeature.Path.State.recordMeeting,
						 action: AppFeature.Path.Action.recordMeeting,
						 then: RecordMeetingView.init(store:)
					)
					
				case let .meeting(meeting, standup: standup):
					MeetingView(meeting: meeting, standup: standup)
				}
			}
		)
    }
}

import Mock
import Domain
import DataManagerImpl

#Preview("Regular") {
	return AppView(
		store: Store(
			initialState: AppFeature.State(
				standupsListState: StandupsListFeature.State()
			)
		) {
			AppFeature()
		} withDependencies: {
			$0.dataManager = .mock(initialData: try? JSONEncoder().encode([Standup.mock]))
		}
	)
}

#Preview("Quick finish meeting") {
	var standup = Standup.mock
	standup.duration = .seconds(6)
	return AppView(
		store: Store(
			initialState: AppFeature.State(
				path: StackState(
					[
						.detail(StandupDetailFeature.State(standup: standup)),
						.recordMeeting(RecordMeetingFeature.State(standup: standup))
					]
				),
				standupsListState: StandupsListFeature.State(
					// standups: [standup]
				)
			)
		) {
			AppFeature()
		} withDependencies: {
			$0.dataManager = .mock(initialData: try? JSONEncoder().encode([Standup.mock]))
		}
	)
}
