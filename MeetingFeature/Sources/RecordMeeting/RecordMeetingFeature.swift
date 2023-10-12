import ComposableArchitecture
import Foundation
import Domain
import SpeechClient

public struct RecordMeetingFeature: Reducer {
	public struct State: Equatable {
		let standup: Standup
		var secondsElapsed: Int
		var speakerIndex: Int
		var transcript: String
		@PresentationState var alert: AlertState<Action.Alert>?
		
		var durationRemaining: Duration {
			standup.duration - .seconds(secondsElapsed)
		}
		
		public init(
			standup: Standup,
			secondsElapsed: Int = 0,
			speakerIndex: Int = 0,
			transcript: String = "",
			alert: AlertState<Action.Alert>? = nil
		) {
			self.standup = standup
			self.secondsElapsed = secondsElapsed
			self.speakerIndex = speakerIndex
			self.transcript = transcript
			self.alert = alert
		}
	}
	
	public enum Action: Equatable {
		public enum Delegate: Equatable {
			case saveMeeting(String)
		}
		
		public enum Alert: Equatable {
			case confirmDiscard
			case confirmSave
		}
		
		case nextButtonTapped
		case endMeetingButtonTapped
		case onTask
		case timerTicked
		case delegate(Delegate)
		case alert(PresentationAction<Alert>)
		case speechResult(String)
	}
	
	@Dependency(\.continuousClock) var clock
	@Dependency(\.speechClient) var speechClient
	@Dependency(\.dismiss) var dismiss
		
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .nextButtonTapped:
				guard state.speakerIndex < state.standup.attendees.count - 1 else {
					state.alert = .endMeeting(isDiscardable: false)
					return .none
				}
				
				state.speakerIndex += 1
				state.secondsElapsed = state.speakerIndex * Int(state.standup.durationPerAttendee.components.seconds)
				return .none
				
			case .endMeetingButtonTapped:
				state.alert = .endMeeting(isDiscardable: true)
				return .none
				
			case .onTask:
				return .run { send in
					await withTaskGroup(of: Void.self) { group in
						group.addTask {
							let status = await speechClient.requestAuthorization()
							
							if status == .authorized {
								do {
									for try await transcript in self.speechClient.start() {
										await send(.speechResult(transcript))
									}
								} catch {
									// TODO: handle error
								}
							}
						}
						
						group.addTask {
							for await _ in self.clock.timer(interval: .seconds(1)) {
								await send(.timerTicked)
							}
						}
					}
				}
				
			case .timerTicked:
				guard state.alert == nil else { return .none }
				
				state.secondsElapsed += 1
				let secondsPerAttendee = Int(state.standup.durationPerAttendee.components.seconds)
				if state.secondsElapsed.isMultiple(of: secondsPerAttendee) {
					if state.speakerIndex == state.standup.attendees.count - 1 {
						return .run { [transcript = state.transcript] send in
							await send(.delegate(.saveMeeting(transcript)))
							await self.dismiss()
						}
					}
					state.speakerIndex += 1
				}
				return .none
				
			case .delegate:
				return .none
				
			case .alert(.presented(.confirmDiscard)):
				return .run { _ in await self.dismiss() }
				
			case .alert(.presented(.confirmSave)):
				return .run { [transcript = state.transcript] send in
					await send(.delegate(.saveMeeting(transcript)))
					await self.dismiss()
				}
				
			case .alert(.dismiss):
				return .none
				
			case let .speechResult(transcript):
				state.transcript = transcript
				return .none
			}
		}
		.ifLet(\.$alert, action: /Action.alert)
	}
	
	public init() {}
}

extension AlertState where Action == RecordMeetingFeature.Action.Alert {
	static func endMeeting(isDiscardable: Bool) -> Self {
		Self {
			TextState("End meeting?")
		} actions: {
			ButtonState(action: .confirmSave) {
				TextState("Save and end")
			}
			if isDiscardable {
				ButtonState(
					role: .destructive, action: .confirmDiscard
				) {
					TextState("Discard")
				}
			}
			ButtonState(role: .cancel) {
				TextState("Resume")
			}
		} message: {
			TextState("You are ending the meeting early. What would you like to do?")
		}
	}
}
