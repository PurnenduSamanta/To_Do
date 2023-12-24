import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _userName = '';
  bool isLoginPage = true;

  startAuthenticating() async {
    FocusScope.of(context).unfocus();
    final validity = _formKey.currentState?.validate();
    if (validity != null && validity) {
      _formKey.currentState?.save();
      submitForm(_email, _password, _userName);
    }
  }

  submitForm(String email, String password, String userName) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential;
    try {
      if (isLoginPage) {
        credential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String? uid = credential.user?.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': userName,
          'email': email,
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                upperPortion(isLoginPage),
                middlePortion(isLoginPage),
                belowPortion(isLoginPage, () {
                  setState(() {
                    isLoginPage = !isLoginPage;
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  upperPortion(bool isLoginPage) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          CircleAvatar(
            radius: 40,
            child: Image(
                width: 80,
                height: 80,
                image: AssetImage('assets/circularAvatar.png')),
          ),
          SizedBox(
            height: 20,
          ),
          Text(isLoginPage ? 'Welcome Back!' : 'Create your account',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 80, right: 80),
            child: Text(
              isLoginPage
                  ? 'Sign in to access your account'
                  : "Welcome! Join us today to explore and experience more",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      );

  middlePortion(bool isLoginPage) => Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            if (!isLoginPage)
              myTextFormField(
                'UserName',
                TextInputType.text,
                'userName',
                (value) {
                  if (value!.isEmpty) {
                    return 'Empty UserName';
                  } else {
                    return null;
                  }
                },
                (value) {
                  _userName = value!;
                },
              ),
            myTextFormField(
              'Email',
              TextInputType.emailAddress,
              'email',
              (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Incorrect email address';
                } else {
                  return null;
                }
              },
              (value) {
                _email = value!;
              },
            ),
            myTextFormField(
              'Password',
              TextInputType.visiblePassword,
              'password',
              (value) {
                if (value!.isEmpty) {
                  return 'Empty password';
                } else {
                  return null;
                }
              },
              (value) {
                _password = value!;
              },
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  startAuthenticating();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                child: Text(
                  isLoginPage ? 'LogIn' : 'SignUp',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      );

  TextFormField myTextFormField(
    String label,
    TextInputType keyBoardType,
    String key,
    String? Function(String?)? onValidate,
    Function(String?)? onSave,
  ) {
    return TextFormField(
      keyboardType: keyBoardType,
      key: ValueKey(key),
      validator: (value) {
        return onValidate!(value);
      },
      onSaved: (value) {
        onSave!(value);
      },
      decoration: InputDecoration(
          label: Center(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade900))),
    );
  }
}

belowPortion(bool isLoginPage, Function onPress) => Column(children: [
      TextButton(
        child: Text(
          isLoginPage ? 'Not a member' : 'Already a member',
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: () {
          onPress();
        },
      ),
      SizedBox(
        height: 40,
      ),
    ]);
