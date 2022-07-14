import 'package:firebase_auth/firebase_auth.dart';

class UserAuthInfo {
  final User? user;
  final Stream? userStream;

  UserAuthInfo({this.user, this.userStream});
}
