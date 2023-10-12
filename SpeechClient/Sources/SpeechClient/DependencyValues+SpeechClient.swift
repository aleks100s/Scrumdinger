import Dependencies

public extension DependencyValues {
	var speechClient: SpeechClient {
		get { self[SpeechClient.self] }
		set { self[SpeechClient.self] = newValue }
	}
}
