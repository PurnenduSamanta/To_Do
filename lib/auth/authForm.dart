import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
                      onPressed: () {},
                      child: Text(isLoginPage ? 'LogIn' : 'SignUp')))
            ],
          )),
    );
  }
}
