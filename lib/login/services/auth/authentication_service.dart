import 'dart:async';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/login/models/barkbuddy_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication_state.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationService {
  static final logger = Logger(name: (AuthenticationService).toString());

  final googleSignIn = GoogleSignIn(
      clientId:
          "669358768813-1islsb4s51asot3c868dbl72k8s1485u.apps.googleusercontent.com");

  Stream<AuthenticationState> get stateStream {
    return FirebaseAuth.instance.authStateChanges().map((firebaseUser) {
      logger.info("auth state changed $firebaseUser");
      if (firebaseUser != null) {
        return AuthenticationState(
          authenticationStatus: AuthenticationStatus.authenticated,
          user: BarkbuddyUser.fromFirebaseUser(firebaseUser),
        );
      } else {
        return const AuthenticationState(
          authenticationStatus: AuthenticationStatus.unauthenticated,
        );
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        //googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return UserCredential
        var userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential;
      }
    } catch (error) {
      logger.error("Unexpected error during google signIn: $error");
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (error) {
      logger.error("Unexpected error during signOut: $error");
      return false;
    }
  }
}
