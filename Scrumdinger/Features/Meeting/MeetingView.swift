//
//  MeetingView.swift
//  Scrumdinger
//
//  Created by Alexander on 04.10.2023.
//

import SwiftUI
import Domain

struct MeetingView: View {
	let meeting: Meeting
	let standup: Standup
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Divider()
					.padding(.bottom)
				Text("Attendees")
					.font(.headline)
				ForEach(self.standup.attendees) { attendee in
					Text(attendee.name)
				}
				Text("Transcript")
					.font(.headline)
					.padding(.top)
				Text(self.meeting.transcript)
			}
		}
		.navigationTitle(Text(self.meeting.date, style: .date))
		.padding()
	}
}
