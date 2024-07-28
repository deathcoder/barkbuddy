class Settings {
  static final Stub stub = Stub();
}

class Stub {
  final bool gemini;
  final bool audio;
  final bool notifications;
  final bool textToSpeech;

  Stub({
    this.gemini = true,
    this.audio = true,
    this.notifications = false,
    this.textToSpeech = true,
  });
}
