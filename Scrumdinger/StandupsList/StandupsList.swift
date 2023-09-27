import SwiftUI
import ComposableArchitecture

struct StandupListView: View {
	let store: StoreOf<StandupsListFeature>
	
	var body: some View {
		WithViewStore(self.store, observe: \.standups) { viewStore in
			List {
				ForEach(viewStore.state) { standup in
					CardView(standup: standup)
						.listRowBackground(standup.theme.mainColor)
				}
			}
			.navigationTitle("Daily standups")
			.toolbar {
				ToolbarItem {
					Button("Add") {
						viewStore.send(.addButtonTapped)
					}
				}
			}
		}
	}
}

#Preview {
	MainActor.assumeIsolated {
		NavigationStack {
			StandupListView(
				store: Store(initialState: StandupsListFeature.State(standups: [.mock])) {
				  StandupsListFeature()
				})
		}
	}
}
