import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/models/login_state.dart';
import 'package:swipeandrescue/models/user_auth_info.dart';
import 'package:swipeandrescue/services/auth_service.dart';

class AuthenticateController extends ChangeNotifier {
  /// Constructor sets the user and userStream variables from authService
  AuthenticateController() {
    _user = authService.user;
    _userStream = authService.userStream;
    _appUser = authService.appUser;
  }

  // Fields
  LoginState _loginState = LoginState.options;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  User? _user;
  late Stream _userStream;
  late BuildContext _currentContext;
  late AppUser _appUser;

  // Properties

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
  AppUser get appUser => _appUser;

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

// Authentication

  /// Sign In/Authenticate with Google
  Future<void> authenticateWithGoogle(BuildContext context) async {
    _currentContext = context;

    UserAuthInfo info = await authService
        .authenticateWithGoogle()
        .catchError(_displayErrorAsDialog);

    _userIsAuthenticatedCheck(info);
  }

  // Sign In/Authenticate with an email address and password
  Future<void> authenticateWithEmail(BuildContext context) async {
    _currentContext = context;

    try {
      UserAuthInfo info = await authService
          .authenticateWithEmail(
              emailLoginTextController.text, passwordLoginTextController.text)
          .catchError(_displayErrorAsDialog);
      _userIsAuthenticatedCheck(info);
    } on FirebaseException catch (e) {
      debugPrint('! ${e.message}');
    }
  }

  /// Sign in anonymously as a guest
  Future<void> continueAsGuest(BuildContext context) async {
    _currentContext = context;

    UserAuthInfo info =
        await authService.continueAsGuest().catchError(_displayErrorAsDialog);

    _userIsAuthenticatedCheck(info);
  }

  /// Signs out of current user
  Future<void> signOut(BuildContext context) async {
    _currentContext = context;
    _loginState = LoginState.options;
    await authService.signOut().catchError(_displayErrorAsDialog);
  }

// Registration

  /// Registers a user with email and password
  Future<void> registerWithEmail() async {
    UserAuthInfo info = await authService.registerNewEmailUser(
        emailRegistrationTextController.text,
        password1RegistrationTextController.text);
  }

// State Management

  /// Switches the state to emailLogin and notifies listeners
  switchToEmailLogin() {
    loginState = LoginState.emailLogin;
    _clearAllTextEditingControllers();
    _pageController.animateToPage(
      1,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 500),
    );
  }

  /// Switches the state to emailRegistration and notifies the listeners
  switchToEmailRegistration() {
    loginState = LoginState.emailRegistration;
    _clearAllTextEditingControllers();
    _pageController.animateToPage(
      2,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 500),
    );
  }

  /// Switches to the login options state, notifies listeners, and
  /// animates the page to page 0
  switchToLoginOptions() async {
    loginState = LoginState.options;
    await _pageController.animateToPage(
      0,
      curve: Curves.easeOutQuad,
      duration: const Duration(milliseconds: 500),
    );
  }

// Helper methods

  /// Sets the state variable based on authentication success/fail
  _userIsAuthenticatedCheck(UserAuthInfo info) async {
    // if user is null, authentication failed
    if (info.user == null) {
      _loginState = LoginState.authenticationFailed;

      Future<void>.delayed(
        const Duration(milliseconds: 200),
      );
      //switchToLoginOptions();

      return;
    }

    // authentication was successful
    _loginState = LoginState.authenticationSuccessful;

    _user = info.user;
    _userStream = info.userStream!;
    _appUser = info.appUser;

    notifyListeners();
  }

  _clearAllTextEditingControllers() {
    emailLoginTextController.text = '';
    passwordLoginTextController.text = '';

    emailRegistrationTextController.text = '';
    password1RegistrationTextController.text = '';
    password2RegistrationTextController.text = '';
  }

  _displayErrorAsDialog(dynamic error) {
    if (error.runtimeType != FirebaseException) {
      debugPrint(error.toString());
      return;
    }

    FirebaseException e = error as FirebaseException;

    debugPrint('${e.message}!');
    showDialog(
      context: _currentContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('An error has occured.'),
        content: Text(e.message ?? 'An error has occured'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          )
        ],
      ),
    );
    return UserAuthInfo(AppUser());
  }
}
