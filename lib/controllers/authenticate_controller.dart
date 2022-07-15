import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:swipeandrescue/models/login_state.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';
import 'package:swipeandrescue/services/auth_service.dart';

class AuthenticateController extends ChangeNotifier {
  LoginState _loginState = LoginState.options;

  AuthenticationService authService = AuthenticationService();
  User? _user;
  late Stream _userStream;
  User? get user => _user;
  Stream get userStream => _userStream;

  AuthenticateController() {
    _user = authService.user;
    _userStream = authService.userStream;
  }

  LoginState get loginState => _loginState;
  set loginState(LoginState newLoginState) {
    _loginState = newLoginState;
    notifyListeners();
  }

  /// Sign In/Authenticate with Google
  Future<void> authenticateWithGoogle() async {
    UserAuthInfo info = await authService.authenticateWithGoogle();

    _authenticationCheck(info);
  }

  // Sign In/Authenticate with an email address and password
  Future<void> authenticateWithEmail(String email, String password) async {
    UserAuthInfo info =
        await authService.authenticateWithEmail(email, password);
    _authenticationCheck(info);
  }

  /// Sign in anonymously as a guest
  Future<void> continueAsGuest() async {
    UserAuthInfo info = await authService.continueAsGuest();

    _authenticationCheck(info);
  }

  /// Switches the state to emailLogin and notifies listeners
  switchToEmailLogin() {
    _loginState = LoginState.emailLogin;
    notifyListeners();
  }

  /// Signs out of current user
  Future<void> signOut() async {
    _loginState = LoginState.options;
    await authService.signOut();
  }

  /// Sets the state variable based on authentication success/fail
  _authenticationCheck(UserAuthInfo info) async {
    // if user is null, authentication failed
    if (info.user == null) {
      _loginState = LoginState.authenticationFailed;
      notifyListeners();
      Future<void>.delayed(
        const Duration(milliseconds: 200),
      );
      _loginState = LoginState.options;
      notifyListeners();
      return;
    }

    // authentication was successful
    _loginState = LoginState.authenticationSuccessful;

    _user = info.user;
    _userStream = info.userStream!;

    notifyListeners();
  }
}
