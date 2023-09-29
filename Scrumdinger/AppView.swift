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
				}
			}
		)
    }
}

#Preview {
	AppView(
		store: Store(initialState: AppFeature.State()) {
			AppFeature()
		}
	)
}
