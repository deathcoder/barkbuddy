import 'dart:typed_data';

/// Manages audio recordings
abstract interface class RecorderService {
  /// Returns the current average amplitude of the recorded audio or -1 if the service is not initialized.
  Future<double> get currentAmplitude;

  /// Sets a callback function to be called after [stopRecording] is invoked.
  ///
  /// The callback receives the recorded audio and its associated ID.
  set audioRecordedCallback(void Function({required Uint8List audio, required int audioId}) onAudioRecorded);

  /// Initializes the recording service.
  Future<void> initialize();

  /// Starts or restarts the recording session.
  ///
  /// If a recording is already in progress, it will be discarded and the callback will not be called.
  Future<void> restartRecording();

  /// Convenience method, is exactly the same as [restartRecording]
  Future<void> startRecording();
  
  /// Stops the current recording session.
  ///
  /// The callback function set by [audioRecordedCallback] will be called with the recorded audio data.
  Future<void> stopRecording();

  /// Releases all resources used by the recording service.
  Future<void> dispose();
}