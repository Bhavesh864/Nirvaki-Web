// Assume you have already set up Firebase authentication.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  // final String userId; // Unique identifier from the login link

  const ChangePasswordPage({super.key});

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';
  String _reenteredPassword = '';
  String _oldPassword = "";
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_newPassword == _reenteredPassword) {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            // Reauthenticate the user with the old password before changing it
            AuthCredential credentials = EmailAuthProvider.credential(email: user.email!, password: _oldPassword);
            await user.reauthenticateWithCredential(credentials);
            // Update the password
            await user.updatePassword(_newPassword);
          }
        } catch (e) {
          // Handle password change errors
          print('Error changing password: $e');
        }
      } else {
        // Passwords don't match, show an error message
        print('Passwords do not match');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Old Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
                onChanged: (value) => _oldPassword = value,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
                onChanged: (value) => _newPassword = value,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Reenter New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please reenter your new password';
                  } else if (value != _newPassword) {
                    return "password not match";
                  }
                  return null;
                },
                onChanged: (value) => _reenteredPassword = value,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
