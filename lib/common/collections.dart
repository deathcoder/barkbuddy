class Collections {
  static final Users users = Users();
}

class Users {
  final Devices devices = Devices();

  final String collection = "users";
}

class Devices {
  final String collection = "devices";
}