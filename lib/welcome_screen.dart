import 'package:booze_app/policy_viewer_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  final Function() onWelcomeScreenDismissed;
  const WelcomeScreen({super.key, required this.onWelcomeScreenDismissed});

  Future<void> _markWelcomeScreenShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeScreenShown', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Booze App!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Discover, Track, and Rate Your Favorite Beers!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Booze App helps you keep a personal log of all the beers you\'ve tried. '
              'Add new beers, track their details, rate them, and even add photos. '
              'Organize your beer journey and never forget a great brew!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            RichText(
              key: const Key('viewTermsAndPrivacyBox'),
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Please read and accept our ",
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PolicyViewerScreen(
                              policyType: PolicyType.termsAndConditions,
                            ),
                          ),
                        );
                      },
                  ),
                  const TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PolicyViewerScreen(
                              policyType: PolicyType.privacyPolicy,
                            ),
                          ),
                        );
                      },
                  ),
                  const TextSpan(text: " before continuing."),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await _markWelcomeScreenShown();
                onWelcomeScreenDismissed();
              },
              child: const Text('Let\'s Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
