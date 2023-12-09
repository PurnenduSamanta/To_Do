import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _userName = '';
  bool isLoginPage = false;

  startAuthenticating() async
  {
    FocusScope.of(context).unfocus();
    final validity = _formKey.currentState?.validate();
    if (validity != null && validity) {
      _formKey.currentState?.save();
      submitForm(_email, _password, _userName);
    }
  }

  submitForm(String email, String password, String userName) async
  {
    final auth = FirebaseAuth.instance;
    UserCredential credential;
    try {
      if (isLoginPage) {
        credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else {
        credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String? uid = credential.user?.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': userName,
          'email': email,
        });
      }
    }
    catch(error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: const EdgeInsets.all(10),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isLoginPage)
                TextFormField(
                  keyboardType: TextInputType.text,
                  key: ValueKey('userName'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Incorrect UserName';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _userName = value!;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide()),
                      labelText: 'UserName'),
                ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Incorrect email address';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _email = value!;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide()),
                    labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                key: ValueKey('password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Incorrect password';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _password = value!;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide()),
                    labelText: 'Password'),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                      onPressed: () {
                        startAuthenticating();
                      },
                      child: Text(isLoginPage ? 'LogIn' : 'SignUp'))),
              Container(child: TextButton(onPressed: () {
                setState(() {
                  isLoginPage = !isLoginPage;
                });
              },
                  child: Text(
                      isLoginPage ? 'Not a member' : 'Already a member')))
            ],
          )),
    );
  }
}
