//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Alexander on 30.09.2023.
//

import SwiftUI

struct MeetingTimerView: View {
	let standup: Standup
	let speakerIndex: Int
	
	var body: some View {
		Circle()
			.strokeBorder(lineWidth: 24)
			.overlay {
				VStack {
					Group {
						if self.speakerIndex
							< self.standup.attendees.count {
							Text(
								self.standup.attendees[self.speakerIndex]
									.name
							)
						} else {
							Text("Someone")
						}
					}
					.font(.title)
					Text("is speaking")
					Image(systemName: "mic.fill")
						.font(.largeTitle)
						.padding(.top)
				}
				.foregroundStyle(self.standup.theme.accentColor)
			}
			.overlay {
				ForEach(
					Array(self.standup.attendees.enumerated()),
					id: \.element.id
				) { index, attendee in
					if index < self.speakerIndex + 1 {
						SpeakerArc(
							totalSpeakers: self.standup.attendees.count,
							speakerIndex: index
						)
						.rotation(Angle(degrees: -90))
						.stroke(
							self.standup.theme.mainColor, lineWidth: 12
						)
					}
				}
			}
			.padding(.horizontal)
	}
}
