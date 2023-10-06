import SwiftUI
import Domain

struct MeetingProgressViewStyle: ProgressViewStyle {
	let mainColor: Color
	let accentColor: Color
	
	func makeBody(
		configuration: Configuration
	) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.fill(accentColor)
				.frame(height: 20)
			
			ProgressView(configuration)
				.tint(mainColor)
				.frame(height: 12)
				.padding(.horizontal)
		}
	}
}

