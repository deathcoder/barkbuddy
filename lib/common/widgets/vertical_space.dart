import 'package:flutter/cupertino.dart';

class VerticalSpace {
  static micro(){
    return const SizedBox(height: 5,);
  }

  static small(){
    return const SizedBox(height: 10,);
  }

  static medium() {
    return const SizedBox(height: 50,);
  }

  static large() {
    return const SizedBox(height: 100,);
  }
}