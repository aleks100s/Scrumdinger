import Speech

public struct SpeechClient {
	public var requestAuthorization: @Sendable () async -> SFSpeechRecognizerAuthorizationStatus
	public var start: @Sendable () -> AsyncThrowingStream<String, Error>
	
	public init(
		requestAuthorization: @Sendable @escaping () async -> SFSpeechRecognizerAuthorizationStatus,
		start: @Sendable @escaping () -> AsyncThrowingStream<String, Error>
	) {
		self.requestAuthorization = requestAuthorization
		self.start = start
	}
}
