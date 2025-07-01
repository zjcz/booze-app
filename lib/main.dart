import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final welcomeScreenShown = prefs.getBool('welcomeScreenShown') ?? false;

  runApp(BoozeApp(welcomeScreenShown: welcomeScreenShown));
}

class BoozeApp extends StatefulWidget {
  final bool welcomeScreenShown;

  const BoozeApp({super.key, required this.welcomeScreenShown});

  @override
  State<BoozeApp> createState() => _BoozeAppState();
}

class _BoozeAppState extends State<BoozeApp> {
  bool _welcomeScreenShown = false;

  @override
  @override
  void initState() {
    super.initState();

    _welcomeScreenShown = widget.welcomeScreenShown;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booze App',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: _welcomeScreenShown
          ? Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Visibility(
                        visible: constraints.maxWidth >= 1200,
                        child: Expanded(
                          child: Container(
                            height: double.infinity,
                            color: Theme.of(context).colorScheme.primary,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Booze App Desktop',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth >= 1200
                            ? constraints.maxWidth / 2
                            : constraints.maxWidth,
                        child: StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return const HomeScreen();
                            }
                            return AuthScreen();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          : WelcomeScreen(
              onWelcomeScreenDismissed: () {
                setState(() => _welcomeScreenShown = true);
              },
            ),
    );
  }
}
