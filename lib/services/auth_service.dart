import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';
import 'package:swipeandrescue/repository/user/firebase_user_repository.dart';
import 'package:swipeandrescue/repository/user/user_repository.dart';

class AuthenticationService {
  /// Used to make AuthenticationService a singleton
  static final AuthenticationService _instance =
      AuthenticationService._internal();

  /// Used to make AuthenticationService a singleton
  factory AuthenticationService() {
    return _instance;
  }

  final UserRepository _userRepository = FirebaseUserRepository();
  User? user;
  late Stream userStream;
  AppUser appUser = AppUser();

  /// Used to make Authentication Service a singleton
  AuthenticationService._internal() {
    user = _userRepository.user;
    userStream = _userRepository.userStream;
  }

  Future<UserAuthInfo> authenticateWithGoogle() async {
    UserAuthInfo info = await _userRepository.authenticateWithGoogle();
    _setProperties(info);
    return info;
  }

  Future<UserAuthInfo> authenticateWithEmail(
      String email, String password) async {
    UserAuthInfo info =
        await _userRepository.authenticateWithEmail(email, password);
    _setProperties(info);
    return info;
  }

  Future<UserAuthInfo> registerNewEmailUser(
      String email, String password) async {
    UserAuthInfo info =
        await _userRepository.registerNewEmailUser(email, password);
    _setProperties(info);

    return info;
  }

  Future<UserAuthInfo> continueAsGuest() async {
    UserAuthInfo info = await _userRepository.continueAsGuest();
    _setProperties(info);
    return info;
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }

  _setProperties(UserAuthInfo info) {
    user = info.user;
    userStream = info.userStream!;
    appUser = info.appUser;
  }
}
