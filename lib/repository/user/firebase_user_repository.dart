import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipeandrescue/repository/user/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  User? _user = FirebaseAuth.instance.currentUser;
  Stream _userStream = FirebaseAuth.instance.authStateChanges();

  @override
  Future<UserAuthInfo> authenticateWithEmail(
      String email, String password) async {
    //try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // set user and user stream variables
    _user = FirebaseAuth.instance.currentUser;
    _userStream = FirebaseAuth.instance.authStateChanges();

    // return UserAuthInfo
    return UserAuthInfo(user: user, userStream: userStream);
    //} on FirebaseException catch (e) {
    //  throw FirebaseException(plugin: e.plugin);
    //  return UserAuthInfo();
    //}
  }

  @override
  Future<UserAuthInfo> authenticateWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      // return empty user auth info if auth failed
      if (googleUser == null) return UserAuthInfo();

      // get Google auth information
      final googleAuth = await googleUser.authentication;
      // create firebase login credential out of google auth info
      final authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // await sign in to firebase with google credentials
      await FirebaseAuth.instance.signInWithCredential(authCredential);

      // set user and stream variables
      _user = FirebaseAuth.instance.currentUser;
      _userStream = FirebaseAuth.instance.authStateChanges();

      // return UserAuthInfo
      return UserAuthInfo(user: user, userStream: userStream);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return UserAuthInfo();
    }
  }

  @override
  Future<UserAuthInfo> continueAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      _user = FirebaseAuth.instance.currentUser;
      _userStream = FirebaseAuth.instance.authStateChanges();
      return UserAuthInfo(user: user, userStream: userStream);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return UserAuthInfo();
    }
  }

  @override
  User? get user => _user;

  @override
  Stream get userStream => _userStream;

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserAuthInfo> registerNewEmailUser(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = FirebaseAuth.instance.currentUser;
      _userStream = FirebaseAuth.instance.authStateChanges();
      return UserAuthInfo(user: user, userStream: userStream);
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('An account already exists for that email.');
      }
      return UserAuthInfo();
    }
  }
}
