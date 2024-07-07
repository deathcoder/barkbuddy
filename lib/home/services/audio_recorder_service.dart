import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  static final logger = Logger(name: (AudioRecorderService).toString());

  bool initialized;
  int audioId;

  late AudioRecorder audioRecorder;

  StreamSubscription<Uint8List>? audioStream;
  Uint8List? currentAudio;

  void Function({required Uint8List audio, required int audioId}) onAudioRecorded =
      ({required Uint8List audio, required int audioId}) => logger.warn("no audio recorded function provided");

  AudioRecorderService():
        initialized = false,
        audioId = 0;

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
       audioStream = await startAudioStream();
     }
   }

   initialized = true;
  }

  Future<StreamSubscription<Uint8List>> startAudioStream() async {
    if(await audioRecorder.isRecording()){
      String message = "start stream requested while audioRecorder is already recording";
      logger.error(message);
      throw Exception(message);
    }

    logger.info("starting audio recording with id: $audioId");
    return (await audioRecorder.startStream(const RecordConfig(
        sampleRate: 44100,
        encoder: AudioEncoder.pcm16bits,
        numChannels: 1
    ))).listen(
            (data) {
          logger.debug("Received audio data on stream, size: ${data.length}");
          if(currentAudio == null) {
            logger.debug("initializing current audio with id: $audioId");
            currentAudio = data;
            return;
          }

          logger.debug("appending new data to existing audio with id $audioId and size: ${currentAudio!.length}");
          currentAudio = Uint8List.fromList(currentAudio! + data);
        },
        onDone: () {
          logger.info("current audio stream is done");
          onAudioRecorded(audio: currentAudio!, audioId: audioId++);
        });
  }

  Future<Amplitude> getAmplitude() {
    return audioRecorder.getAmplitude();
  }

  Future<void> stop() {
    return audioRecorder.stop();
  }

  Future<void> restart() async {
    await audioRecorder.cancel();
    await audioStream?.cancel();
    currentAudio = null;
    audioStream = await startAudioStream();
  }

  Future<void> dispose() async {
    await audioStream?.cancel();
    await audioRecorder.dispose();
  }
}