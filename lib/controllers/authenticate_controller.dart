import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/login_state.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';
import 'package:swipeandrescue/services/auth_service.dart';

class AuthenticateController extends ChangeNotifier {
  /// Constructor sets the user and userStream variables from authService
  AuthenticateController() {
    _user = authService.user;
    _userStream = authService.userStream;
  }

  LoginState _loginState = LoginState.options;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  User? _user;
  late Stream _userStream;

  final TextEditingController emailLoginTextController =
      TextEditingController();
  final TextEditingController passwordLoginTextController =
      TextEditingController();
  final TextEditingController emailRegistrationTextController =
      TextEditingController();
  final TextEditingController password1RegistrationTextController =
      TextEditingController();
  final TextEditingController password2RegistrationTextController =
      TextEditingController();

  AuthenticationService authService = AuthenticationService();

  User? get user => _user;
  Stream get userStream => _userStream;
  PageController get pageController => _pageController;

  LoginState get loginState => _loginState;
  set loginState(LoginState newLoginState) {
    _loginState = newLoginState;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  /// Sign In/Authenticate with Google
  Future<void> authenticateWithGoogle() async {
    UserAuthInfo info = await authService.authenticateWithGoogle();

    _authenticationCheck(info);
  }

  // Sign In/Authenticate with an email address and password
  Future<void> authenticateWithEmail() async {
    UserAuthInfo info = await authService.authenticateWithEmail(
        emailLoginTextController.text, passwordLoginTextController.text);
    _authenticationCheck(info);
  }

  /// Registers a user with email and password
  Future<void> registerWithEmail() async {
    UserAuthInfo info = await authService.registerNewEmailUser(
        emailRegistrationTextController.text,
        password1RegistrationTextController.text);
  }

  /// Sign in anonymously as a guest
  Future<void> continueAsGuest() async {
    UserAuthInfo info = await authService.continueAsGuest();

    _authenticationCheck(info);
  }

  /// Switches the state to emailLogin and notifies listeners
  switchToEmailLogin() {
    loginState = LoginState.emailLogin;
    _pageController.animateToPage(
      1,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 500),
    );
  }

  /// Switches the state to emailRegistration and notifies the listeners
  switchToEmailRegistration() {
    loginState = LoginState.emailRegistration;
    _pageController.animateToPage(
      2,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 500),
    );
  }

  String? validateEmailAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Please enter a longer password (minimum 6 characters)';
    }

    return null;
  }

  switchToLoginOptions() async {
    loginState = LoginState.options;
    await _pageController.animateToPage(
      0,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 500),
    );
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

      Future<void>.delayed(
        const Duration(milliseconds: 200),
      );
      switchToLoginOptions();

      return;
    }

    // authentication was successful
    _loginState = LoginState.authenticationSuccessful;

    _user = info.user;
    _userStream = info.userStream!;

    notifyListeners();
  }
}
