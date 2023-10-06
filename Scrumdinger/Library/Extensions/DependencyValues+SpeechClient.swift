//
//  SpeechClient.swift
//  Scrumdinger
//
//  Created by Alexander on 03.10.2023.
//

import Dependencies
import SpeechClient

extension DependencyValues {
	var speechClient: SpeechClient {
		get { self[SpeechClient.self] }
		set { self[SpeechClient.self] = newValue }
	}
}
