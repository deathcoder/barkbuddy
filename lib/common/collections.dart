class Collections {
  static final Users users = Users();
}

class Users {
  final String collection = "users";

  final Devices devices = Devices();
  final Services services = Services();
  final Notifications notifications = Notifications();
}

class Devices {
  final String collection = "devices";
}

class Services {
  final String collection = "services";
  final String geminiId = gemini;
  final String googleTtsId = googleTts;
  final String recorderId = recorder;

  static const gemini = "gemini";
  static const googleTts = "googleTts";
  static const recorder = "recorder";
}

class Notifications {
  final String collection = "notifications";
}


