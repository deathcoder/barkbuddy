class Settings {
  static final Stub stub = Stub();
}

class Stub {
  final bool gemini;
  final bool audio;
  final bool notifications;

  Stub({
    this.gemini = true,
    this.audio = true,
    this.notifications = true,
  });
}
