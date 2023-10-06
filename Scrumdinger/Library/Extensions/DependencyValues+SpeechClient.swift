import Dependencies
import SpeechClient
import SpeechClientImpl

extension DependencyValues {
	var speechClient: SpeechClient {
		get { self[SpeechClient.self] }
		set { self[SpeechClient.self] = newValue }
	}
}
