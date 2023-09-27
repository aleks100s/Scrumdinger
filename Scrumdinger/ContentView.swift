//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Alexander on 26.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
		NavigationStack {
			StandupListView(
				store: Store(
					initialState: StandupsListFeature.State(standups: [.mock])
				) {
				  StandupsListFeature()
				}
			)
		}
    }
}

#Preview {
    ContentView()
}
