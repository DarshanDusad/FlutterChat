import 'dart:io';

import 'package:flutter/material.dart';
import './pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Function _submitAuthForm;
  final bool isLoading;
  AuthForm(this._submitAuthForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String userEmail = " ";
  String username = " ";
  String password = " ";
  File image;
  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (image == null && !isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image!"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    widget._submitAuthForm(
        userEmail.trim(), password.trim(), username, isLogin, context, image);
  }

  void pickedImage(File img) {
    image = img;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin)
                    UserImagePicker(
                      pickedImage,
                    ),
                  TextFormField(
                    key: ValueKey("email"),
                    onSaved: (input) {
                      userEmail = input;
                    },
                    validator: (input) {
                      if (!input.contains("@") ||
                          !input.contains(".com") ||
                          input.isEmpty) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      onSaved: (input) {
                        username = input;
                      },
                      validator: (input) {
                        if (input.isEmpty || input.length < 8) {
                          return "Please enter a user name of atleast 8 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    onSaved: (input) {
                      password = input;
                    },
                    validator: (input) {
                      if (input.isEmpty || input.length < 7) {
                        return "Please enter a password of atleast 7 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(isLogin ? "Login" : "Sign Up"),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        isLogin ? "Create New Account" : "Log In",
                      ),
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
