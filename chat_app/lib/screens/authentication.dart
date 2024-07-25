import 'dart:io';

import 'package:chat_app/screens/image_picker_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AuthenicationState();
  }
}

class _AuthenicationState extends State<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _enteredImage;
  bool _isLogin = true;
  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_isLogin && _enteredImage == null) {
        return;
      }
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        if (_isLogin) {
          await _firebase.signInWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
        } else {
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
                  email: _enteredEmail, password: _enteredPassword);
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('users_images')
              .child('${userCredentials.user!.uid}.jpg');
          await storageRef.putFile(_enteredImage!);
          final imageUrl = await storageRef.getDownloadURL();
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
                'username': _enteredUsername,
                'email': _enteredEmail,
                'imageurl': imageUrl,
              });
        }
      } on FirebaseAuthException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message ?? "Authincation Error")));
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Authincation Error")));
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('lib/assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            ImagePickerScreen(
                              onPickImage: (pickedImage) {
                                _enteredImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            initialValue: _enteredEmail,
                            decoration: const InputDecoration(
                                label: Text('Email Address')),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            initialValue: _enteredPassword,
                            decoration:
                                const InputDecoration(label: Text('Password')),
                            obscureText: true,
                            obscuringCharacter: '*',
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          if (_isLoading) const CircularProgressIndicator(),
                          if (!_isLoading)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(_isLogin ? 'Log In' : 'Sign Up'),
                            ),
                          if (!_isLoading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'You don\'t have account? Create one instead.'
                                  : 'Do you have account? Log in instead.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
