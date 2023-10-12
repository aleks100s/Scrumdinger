import SwiftUI

public struct TrailingIconLabelStyle: LabelStyle {
	public init() {}
	
	public func makeBody(
		configuration: Configuration
	) -> some View {
		HStack {
			configuration.title
			configuration.icon
		}
	}
}

public extension LabelStyle where Self == TrailingIconLabelStyle {
	static var trailingIcon: Self { Self() }
}
