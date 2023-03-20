import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/firebase_options.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/views/authenticate/authenticate_screen.dart';
import 'package:swipeandrescue/views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // set orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticateController authenticateController = AuthenticateController();

    return MaterialApp(
        theme: CustomTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: ChangeNotifierProvider(
          create: (context) => AuthenticateController(),
          builder: (context, child) => StreamBuilder(
            stream: authenticateController.userStream,
            builder: (context, snapshot) {
              debugPrint('User stream triggered a re-build...');
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
                return const HomeScreen();
              }

              // user is logged out
              return const AuthenticationScreen();
            },
          ),
        ));
  }
}
