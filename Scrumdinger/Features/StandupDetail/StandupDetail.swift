//
//  StandupDetail.swift
//  Scrumdinger
//
//  Created by Alexander on 27.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct StandupDetail: View {
	let store: StoreOf<StandupDetailFeature>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			List {
				Section {
					NavigationLink {
						// Do something
					} label: {
						Label("Start Meeting", systemImage: "timer")
							.font(.headline)
							.foregroundColor(.accentColor)
					}
					HStack {
						Label("Length", systemImage: "clock")
						Spacer()
						Text(viewStore.standup.duration.formatted(.units()))
					}
					
					HStack {
						Label("Theme", systemImage: "paintpalette")
						Spacer()
						Text(viewStore.standup.theme.name)
							.padding(4)
							.foregroundColor(viewStore.standup.theme.accentColor)
							.background(viewStore.standup.theme.mainColor)
							.cornerRadius(4)
					}
				} header: {
					Text("Standup Info")
				}
				
				if !viewStore.standup.meetings.isEmpty {
					Section {
						ForEach(viewStore.standup.meetings) { meeting in
							NavigationLink {
								// Do something
							} label: {
								HStack {
									Image(systemName: "calendar")
									Text(meeting.date, style: .date)
									Text(meeting.date, style: .time)
								}
							}
						}
						.onDelete { indices in
							viewStore.send(.deleteMeetings(indices))
						}
					} header: {
						Text("Past meetings")
					}
				}
				
				Section {
					ForEach(viewStore.standup.attendees) { attendee in
						Label(attendee.name, systemImage: "person")
					}
				} header: {
					Text("Attendees")
				}
				
				Section {
					Button("Delete") {
						viewStore.send(.deleteButtonTapped)
					}
					.foregroundColor(.red)
					.frame(maxWidth: .infinity)
				}
			}
			.navigationTitle(viewStore.standup.title)
			.toolbar {
				Button("Edit") {
					viewStore.send(.editButtonTapped)
				}
			}
			.sheet(store: store.scope(state: \.$editStandup, action: { .editStandup($0) })) { store in
				NavigationStack {
					StandupFormView(store: store)
						.navigationTitle("Edit standup")
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

#Preview {
	NavigationStack {
		StandupDetail(
			store:
				Store(initialState: StandupDetailFeature.State(standup: .mock)) {
					StandupDetailFeature()
				}
		)
	}
}
