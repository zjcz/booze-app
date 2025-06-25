import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  final Function(String, String) onRegister;

  const RegisterWidget({super.key, required this.onRegister});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      widget.onRegister(_emailController.text, _passwordController.text);
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                autofillHints: [AutofillHints.email],
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an email address'
                    : null,
              ),
              TextFormField(
                autofillHints: [AutofillHints.newPassword],
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value != _repeatPasswordController.text) {
                    return 'Passwords do not match';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                autofillHints: [AutofillHints.newPassword],
                controller: _repeatPasswordController,
                decoration: InputDecoration(labelText: 'Repeat Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(onPressed: _register, child: Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}
