import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:record/record.dart';

import 'recorder_service.dart';

class AudioRecorderService implements RecorderService {
  static final logger = Logger(name: (AudioRecorderService).toString());

  bool initialized;
  int audioId;

  late AudioRecorder audioRecorder;

  StreamSubscription<Uint8List>? audioStream;
  Uint8List? currentAudio;

  void Function({required Uint8List audio, required int audioId}) audioRecordedCallback =
      ({required Uint8List audio, required int audioId}) => logger.warn("no audio recorded function provided");

  AudioRecorderService()
      : initialized = false,
        audioId = 0;

  @override
  Future<double> get currentAmplitude async {
    return (await audioRecorder.getAmplitude()).current;
  }

  @override
  Future<void> initialize() async {
    // avoid reinitialization
    if (initialized) {
      return;
    }

    // initialize audio recorder
    audioRecorder = AudioRecorder();
    // acquire permission
    if (await audioRecorder.hasPermission()) {
      if (!await audioRecorder.isRecording()) {
        // start recording
        logger.info("[initialize] starting audio recording");

        audioStream = await _startAudioStream();
      }
    }

    initialized = true;
  }


  @override
  Future<void> startRecording() {
    return restartRecording();
  }

  @override
  Future<void> restartRecording() async {
    await audioStream?.cancel();
    await audioRecorder.cancel();
    currentAudio = null;
    audioStream = await _startAudioStream();
  }

  @override
  Future<void> stopRecording() {
    return audioRecorder.stop();
  }

  @override
  Future<void> dispose() async {
    await audioStream?.cancel();
    await audioRecorder.dispose();
  }

  Future<StreamSubscription<Uint8List>> _startAudioStream() async {
    if (await audioRecorder.isRecording()) {
      String message = "start stream requested while audioRecorder is already recording";
      logger.error(message);
      throw Exception(message);
    }

    logger.debug("starting audio recording with id: $audioId");
    return (await audioRecorder
        .startStream(const RecordConfig(sampleRate: 44100, encoder: AudioEncoder.pcm16bits, numChannels: 1)))
        .listen((data) {
      logger.debug("Received audio data on stream, size: ${data.length}");
      if (currentAudio == null) {
        logger.debug("initializing current audio with id: $audioId");
        currentAudio = data;
        return;
      }

      logger.debug("appending new data to existing audio with id $audioId and size: ${currentAudio!.length}");
      currentAudio = Uint8List.fromList(currentAudio! + data);
    }, onDone: () {
      logger.info("current audio stream is done");
      audioRecordedCallback(audio: currentAudio!, audioId: audioId++);
    });
  }


}
