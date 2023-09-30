//
//  RecordMeetingView.swift
//  Scrumdinger
//
//  Created by Alexander on 30.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct RecordMeetingView: View {
	let store: StoreOf<RecordMeetingFeature>
	
	var body: some View {
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
		}
	}
}

#Preview {
  MainActor.assumeIsolated {
	NavigationStack {
	  RecordMeetingView(
		store: Store(initialState: RecordMeetingFeature.State(standup: .mock)) {
			RecordMeetingFeature()
		}
	  )
	}
  }
}
