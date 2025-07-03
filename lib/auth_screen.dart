import 'package:booze_app/data/firebase_service.dart';
import 'package:booze_app/widgets/register_widget.dart';
import 'package:booze_app/widgets/sign_in_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum AuthMode { signIn, register }

class AuthScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  const AuthScreen({super.key, required this.firebaseService});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthMode mode = AuthMode.signIn;

  Future<void> _login(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await widget.firebaseService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseServiceException catch (e) {
      // Handle login errors
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
    }
  }

  Future<void> _register(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await widget.firebaseService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseServiceException catch (e) {
      // Handle registration errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mode == AuthMode.signIn ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (mode == AuthMode.register)
                  RegisterWidget(
                    onRegister: (email, password) {
                      _register(email, password);
                    },
                  )
                else
                  SignInWidget(
                    onSignIn: (email, password) {
                      _login(email, password);
                    },
                  ),
                SizedBox(height: 20),
                RichText(
                  key: Key('switchModeText'),
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: mode == AuthMode.signIn
                            ? "Don't have an account? "
                            : 'Have an account? ',
                      ),
                      TextSpan(
                        text: mode == AuthMode.signIn
                            ? 'Register now'
                            : 'Click to sign in',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              mode = mode == AuthMode.signIn
                                  ? AuthMode.register
                                  : AuthMode.signIn;
                            });
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
