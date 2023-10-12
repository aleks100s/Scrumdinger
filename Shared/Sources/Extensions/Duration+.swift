public extension Duration {
	var minutes: Double {
		get { Double(components.seconds / 60) }
		set { self = .seconds(newValue * 60) }
	}
}
