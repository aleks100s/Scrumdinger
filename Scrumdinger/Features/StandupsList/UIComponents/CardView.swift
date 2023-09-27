import SwiftUI

struct CardView: View {
	let standup: Standup
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(self.standup.title)
				.font(.headline)
			Spacer()
			HStack {
				Label(
					"\(self.standup.attendees.count)",
					systemImage: "person.3"
				)
				Spacer()
				Label(
					self.standup.duration.formatted(.units()),
					systemImage: "clock"
				)
				.labelStyle(.trailingIcon)
			}
			.font(.caption)
		}
		.padding()
		.foregroundColor(self.standup.theme.accentColor)
	}
}
