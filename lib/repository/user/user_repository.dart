import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';

abstract class UserRepository {
  final user = FirebaseAuth.instance.currentUser;
  final Stream userStream = FirebaseAuth.instance.authStateChanges();
  AppUser appUser = AppUser();

  Future<UserAuthInfo> authenticateWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo(AppUser());
  }

  Future<UserAuthInfo> authenticateWithEmail(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo(AppUser());
  }

  Future<UserAuthInfo> continueAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo(AppUser());
  }

  Future<UserAuthInfo> registerNewEmailUser(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo(AppUser());
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> updateUserRecord(AppUser appUser) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
