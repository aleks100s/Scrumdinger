//
//  MeetingProgressView.swift
//  Scrumdinger
//
//  Created by Alexander on 30.09.2023.
//

import SwiftUI

struct MeetingProgressViewStyle: ProgressViewStyle {
	var theme: Theme
	
	func makeBody(
		configuration: Configuration
	) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.fill(self.theme.accentColor)
				.frame(height: 20)
			
			ProgressView(configuration)
				.tint(self.theme.mainColor)
				.frame(height: 12)
				.padding(.horizontal)
		}
	}
}

