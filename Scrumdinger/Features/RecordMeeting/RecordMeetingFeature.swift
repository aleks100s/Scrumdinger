//
//  RecordMeetingfeature.swift
//  Scrumdinger
//
//  Created by Alexander on 30.09.2023.
//

import ComposableArchitecture
import Foundation
import Speech

struct RecordMeetingFeature: Reducer {
	struct State: Equatable {
		let standup: Standup
		var secondsElapsed = 0
		var speakerIndex = 0
		
		var durationRemaining: Duration {
			standup.duration - .seconds(secondsElapsed)
		}
	}
	
	enum Action: Equatable {
		case nextButtonTapped
		case endMeetingButtonTapped
		case onTask
		case timerTicked
	}
	
	@Dependency(\.continuousClock) var clock
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .nextButtonTapped:
				return .none
				
			case .endMeetingButtonTapped:
				return .none
				
			case .onTask:
				return .run { send in
					let result = await withUnsafeContinuation { continuation in
						SFSpeechRecognizer.requestAuthorization { status in
							continuation.resume(with: .success(status))
						}
					}
					for await _ in self.clock.timer(interval: .seconds(1)) {
						await send(.timerTicked)
					}
				}
				
			case .timerTicked:
				state.secondsElapsed += 1
				return .none
			}
		}
	}
}
