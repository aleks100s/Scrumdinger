import SwiftUI
import Domain
import DesignSystem

struct ThemePicker: View {
	@Binding var selection: Theme
	
	var body: some View {
		Picker("Theme", selection: self.$selection) {
			ForEach(Theme.allCases) { theme in
				ZStack {
					RoundedRectangle(cornerRadius: 4)
						.fill(theme.mainColor)
					Label(theme.name, systemImage: "paintpalette")
						.padding(4)
				}
				.foregroundColor(theme.accentColor)
				.fixedSize(horizontal: false, vertical: true)
				.tag(theme)
			}
		}
	}
}
