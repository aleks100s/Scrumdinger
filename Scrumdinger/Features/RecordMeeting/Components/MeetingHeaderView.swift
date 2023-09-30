//
//  MeetingHeaderView.swift
//  Scrumdinger
//
//  Created by Alexander on 30.09.2023.
//

import SwiftUI

struct MeetingHeaderView: View {
	let secondsElapsed: Int
	let durationRemaining: Duration
	let theme: Theme
	
	var body: some View {
		VStack {
			ProgressView(value: self.progress)
				.progressViewStyle(
					MeetingProgressViewStyle(theme: self.theme)
				)
			HStack {
				VStack(alignment: .leading) {
					Text("Time Elapsed")
						.font(.caption)
					Label(
						Duration.seconds(self.secondsElapsed)
							.formatted(.units()),
						systemImage: "hourglass.bottomhalf.fill"
					)
				}
				Spacer()
				VStack(alignment: .trailing) {
					Text("Time Remaining")
						.font(.caption)
					Label(
						self.durationRemaining.formatted(.units()),
						systemImage: "hourglass.tophalf.fill"
					)
					.font(.body.monospacedDigit())
					.labelStyle(.trailingIcon)
				}
			}
		}
		.padding([.top, .horizontal])
	}
	
	private var totalDuration: Duration {
		.seconds(self.secondsElapsed) + self.durationRemaining
	}
	
	private var progress: Double {
		guard self.totalDuration > .seconds(0)
		else { return 0 }
		return Double(self.secondsElapsed)
		/ Double(self.totalDuration.components.seconds)
	}
}
