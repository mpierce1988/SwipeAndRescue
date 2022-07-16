import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/firebase_options.dart';
import 'package:swipeandrescue/services/auth_service.dart';
import 'package:swipeandrescue/views/authenticate/authenticate_screen.dart';
import 'package:swipeandrescue/views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authenticateController = AuthenticateController();

    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => authenticateController,
        child: StreamBuilder(
          stream: AuthenticationService().userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // waiting for response
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            } else if (snapshot.hasError) {
              // error occured
              return const Scaffold(
                body: Center(
                  child: Text(
                      "An error connecting to the Firebase userStream has occured."),
                ),
              );
            } else if (snapshot.hasData) {
              // user is logged in
              return HomeScreen();
            }

            // user is logged out
            return const AuthenticationScreen();
          },
        ),
      ),
    );
  }
}
