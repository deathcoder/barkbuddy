class Collections {
  static final Users users = Users();
}

class Users {
  final Devices devices = Devices();
  final Services services = Services();

  final String collection = "users";
}

class Devices {
  final String collection = "devices";
}

class Services {
  final String collection = "services";
  final String geminiId = gemini;
  final String googleTtsId = googleTts;

  static const gemini = "gemini";
  static const googleTts = "googleTts";
}


