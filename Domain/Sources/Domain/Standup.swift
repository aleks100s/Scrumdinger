import Foundation

public struct Standup: Equatable, Identifiable, Codable {
	public let id: UUID
	public var attendees: [Attendee]
	public var duration: Duration
	public var meetings: [Meeting]
	public var theme: Theme
	public var title: String
	
	public var durationPerAttendee: Duration {
		self.duration / self.attendees.count
	}
	
	public init(
		id: UUID,
		attendees: [Attendee] = [],
		duration: Duration = Duration.seconds(60 * 5),
		meetings: [Meeting] = [],
		theme: Theme = .bubblegum,
		title: String = ""
	) {
		self.id = id
		self.attendees = attendees
		self.duration = duration
		self.meetings = meetings
		self.theme = theme
		self.title = title
	}
}
