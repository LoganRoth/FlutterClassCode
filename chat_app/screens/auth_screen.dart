import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File imageFile,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authRes;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authRes = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authRes = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authRes.user.uid + '.jpeg');
        await ref.putFile(imageFile).onComplete;

        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authRes.user.uid)
            .setData({
          'username': username,
          'email': email,
          'imageUrl': url,
        });
      }
    } on PlatformException catch (err) {
      var msg = 'An error occurred, please check your credentials';
      if (err.message != null) {
        msg = err.message;
      }

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
