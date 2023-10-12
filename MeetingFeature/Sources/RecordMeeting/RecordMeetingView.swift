import SwiftUI
import ComposableArchitecture

public struct RecordMeetingView: View {
	let store: StoreOf<RecordMeetingFeature>
	
	public init(store: StoreOf<RecordMeetingFeature>) {
		self.store = store
	}
	
	public var body: some View {
		WithViewStore(
			self.store, observe: { $0 }
		) { viewStore in
			ZStack {
				RoundedRectangle(cornerRadius: 16)
					.fill(viewStore.standup.theme.mainColor)
				
				VStack {
					MeetingHeaderView(
						secondsElapsed: viewStore.secondsElapsed,
						durationRemaining: viewStore.durationRemaining,
						theme: viewStore.standup.theme
					)
					MeetingTimerView(
						standup: viewStore.standup,
						speakerIndex: viewStore.speakerIndex
					)
					MeetingFooterView(
						standup: viewStore.standup,
						nextButtonTapped: {
							viewStore.send(.nextButtonTapped)
						},
						speakerIndex: viewStore.speakerIndex
					)
				}
			}
			.padding()
			.foregroundColor(viewStore.standup.theme.accentColor)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("End meeting") {
						viewStore.send(.endMeetingButtonTapped)
					}
				}
			}
			.navigationBarBackButtonHidden(true)
			.task {
				await viewStore.send(.onTask).finish()
			}
			.alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
		}
	}
}

import Domain
import Mock

#Preview {
  MainActor.assumeIsolated {
	NavigationStack {
	  RecordMeetingView(
		store: Store(initialState: RecordMeetingFeature.State(standup: Standup.mock)) {
			RecordMeetingFeature()
		}
	  )
	}
  }
}
