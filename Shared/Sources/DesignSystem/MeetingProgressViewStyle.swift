import SwiftUI
import Domain

public struct MeetingProgressViewStyle: ProgressViewStyle {
	let mainColor: Color
	let accentColor: Color
	
	public init(mainColor: Color, accentColor: Color) {
		self.mainColor = mainColor
		self.accentColor = accentColor
	}
	
	public func makeBody(
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

