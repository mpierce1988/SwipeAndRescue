import 'package:firebase_auth/firebase_auth.dart';
import 'package:swipeandrescue/models/app_user.dart';

class UserAuthInfo {
  final User? user;
  final Stream? userStream;
  AppUser appUser = AppUser();

  UserAuthInfo(this.appUser, {this.user, this.userStream});
}
