//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Alexander on 26.09.2023.
//

import SwiftUI
import ComposableArchitecture

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
				}
			}
		)
    }
}

#Preview("Regular") {
	return AppView(
		store: Store(
			initialState: AppFeature.State(
				standupsListState: StandupsListFeature.State(
					standups: [.mock]
				)
			)
		) {
			AppFeature()
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
					standups: [standup]
				)
			)
		) {
			AppFeature()
		}
	)
}
