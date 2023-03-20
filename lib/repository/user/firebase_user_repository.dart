import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/models/shelter_model.dart';
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
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // set user and user stream variables
    _user = FirebaseAuth.instance.currentUser;
    _userStream = FirebaseAuth.instance.authStateChanges();

    // get current user information, if its available, from user collection
    AppUser? appUser = await getUserRecord(user!.uid);

    // if there is no user record, create one
    appUser ??= await createUserRecord(user!);

    // return UserAuthInfo
    return UserAuthInfo(appUser, user: user, userStream: userStream);
    //} on FirebaseException catch (e) {
    //  throw FirebaseException(plugin: e.plugin);
    //  return UserAuthInfo();
    //}
  }

  @override
  Future<UserAuthInfo> authenticateWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(
        // client id for web login
        clientId:
            '654567059361-9fj4u324p2qnpoi05ivrd6saekqe1sh2.apps.googleusercontent.com',
      ).signIn();

      // return empty user auth info if auth failed
      if (googleUser == null) return UserAuthInfo(AppUser());

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

      // get current user information, if its available, from user collection
      AppUser? appUser = await getUserRecord(user!.uid);

      // if there is no user record, create one
      appUser ??= await createUserRecord(user!);

      // return UserAuthInfo
      return UserAuthInfo(appUser, user: user, userStream: userStream);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return UserAuthInfo(AppUser());
    }
  }

  @override
  Future<UserAuthInfo> continueAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      _user = FirebaseAuth.instance.currentUser;
      _userStream = FirebaseAuth.instance.authStateChanges();

// get current user information, if its available, from user collection
      AppUser? appUser = await getUserRecord(user!.uid);

      // if there is no user record, create one
      appUser ??= await createUserRecord(user!);

      return UserAuthInfo(appUser, user: user, userStream: userStream);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return UserAuthInfo(AppUser());
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = FirebaseAuth.instance.currentUser;
      _userStream = FirebaseAuth.instance.authStateChanges();

      // get current user information, if its available, from user collection
      AppUser? appUser = await getUserRecord(user!.uid);

      // if there is no user record, create one
      appUser ??= await createUserRecord(user!);

      return UserAuthInfo(appUser, user: user, userStream: userStream);
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('An account already exists for that email.');
      }
      return UserAuthInfo(AppUser());
    }
  }

  @override
  Future<AppUser> updateUserRecord(AppUser appUser) async {
    // get reference to the user document
    var ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();

    if (ref.exists) {
      // update AppUser from auth service
      appUser.displayName =
          FirebaseAuth.instance.currentUser!.displayName ?? '';
      appUser.email = FirebaseAuth.instance.currentUser!.email ?? '';
      // update document
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .set(appUser.toJson(), SetOptions(merge: true));
      appUser.userId = ref.id;
    } else {
      // // create document
      // // update appUser from auth service
      // appUser.displayName =
      //     FirebaseAuth.instance.currentUser!.displayName ?? '';
      // appUser.email = FirebaseAuth.instance.currentUser!.email ?? '';
      // // create new document with auto generated ID
      // final newUser = FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_user!.uid)
      //     .set(appUser.toJson());

      createUserRecord(_user!);
    }

    return appUser;
  }

  @override
  AppUser appUser = AppUser();

  /// Gets the AppUser
  @override
  Future<AppUser?> getUserRecord(String userId) async {
    // get reference to the user document
    var ref =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // check if document exists, if so, return the AppUser information
    if (ref.exists) {
      return (AppUser.fromJson(ref.data() ?? {}));
    }

    // else, return null
    return null;
  }

  @override
  Future<AppUser> createUserRecord(User user) async {
    AppUser appUser = AppUser();

    // create document
    // update appUser from auth service
    appUser.displayName = FirebaseAuth.instance.currentUser!.displayName ?? '';
    appUser.email = FirebaseAuth.instance.currentUser!.email ?? '';
    appUser.userId = user.uid;
    appUser.favouriteAnimals = [];
    appUser.shelter = Shelter(shelterId: '', shelterName: '');
    // create new document with auto generated ID from auth service
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(appUser.toJson());

    return appUser;
  }
}
