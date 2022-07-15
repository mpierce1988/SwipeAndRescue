import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';

abstract class UserRepository {
  final user = FirebaseAuth.instance.currentUser;
  final Stream userStream = FirebaseAuth.instance.authStateChanges();

  Future<UserAuthInfo> authenticateWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo();
  }

  Future<UserAuthInfo> authenticateWithEmail(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo();
  }

  Future<UserAuthInfo> continueAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo();
  }

  Future<UserAuthInfo> registerNewEmailUser(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return UserAuthInfo();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
