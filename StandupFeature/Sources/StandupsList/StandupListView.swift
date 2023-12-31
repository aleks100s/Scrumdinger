import SwiftUI
import ComposableArchitecture
import StandupForm
import Mock

public struct StandupListView: View {
	let store: StoreOf<StandupsListFeature>
	
	public init(store: StoreOf<StandupsListFeature>) {
		self.store = store
	}
	
	public var body: some View {
		WithViewStore(self.store, observe: \.standups) { viewStore in
			List {
				ForEach(viewStore.state) { standup in
					Button {
						viewStore.send(.standupCardTapped(standup))
					} label: {
						CardView(standup: standup)
					}
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
			.sheet(
				store: self.store.scope(
					state: \.$addStandup,
					action: { .addStandup($0) }
				)
			) { (store: StoreOf<StandupFormFeature>) in
				NavigationStack {
					StandupFormView(store: store)
						.navigationTitle("New standup")
						.toolbar {
							ToolbarItem {
								Button("Save") {
									viewStore.send(.saveStandupButtonTapped)
								}
							}
							
							ToolbarItem(placement: .cancellationAction) {
								Button("Cancel") {
									viewStore.send(.cancelStandupButtonTapped)
								}
							}
						}
				}
			}
		}
	}
}

import Domain
import Mock

#Preview {
	MainActor.assumeIsolated {
		NavigationStack {
			StandupListView(
				store: Store(
					initialState: StandupsListFeature.State()
				) {
				  StandupsListFeature()
				} withDependencies: {
					$0.dataManager = .mock(initialData: try? JSONEncoder().encode([Standup.mock]))
				}
			)
		}
	}
}
