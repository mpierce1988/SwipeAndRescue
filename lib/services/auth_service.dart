import 'package:swipeandrescue/models/user_auth_info.dart';
import 'package:swipeandrescue/repository/user/firebase_user_repository.dart';
import 'package:swipeandrescue/repository/user/user_repository.dart';

class AuthenticationService {
  final UserRepository userRepository = FirebaseUserRepository();

  Future<UserAuthInfo> authenticateWithGoogle() async {
    UserAuthInfo info = await FirebaseUserRepository().authenticateWithGoogle();
    return info;
  }

  Future<UserAuthInfo> authenticateWithEmail(
      String email, String password) async {
    UserAuthInfo info =
        await FirebaseUserRepository().authenticateWithEmail(email, password);
    return info;
  }

  Future<UserAuthInfo> continueAsGuest() async {
    UserAuthInfo info = await FirebaseUserRepository().continueAsGuest();
    return info;
  }
}
