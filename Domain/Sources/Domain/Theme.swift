public enum Theme:
	String,
	CaseIterable,
	Equatable,
	Hashable,
	Identifiable,
	Codable
{
	case bubblegum
	case buttercup
	case indigo
	case lavender
	case magenta
	case navy
	case orange
	case oxblood
	case periwinkle
	case poppy
	case purple
	case seafoam
	case sky
	case tan
	case teal
	case yellow
	
	public var id: Self { self }
}
