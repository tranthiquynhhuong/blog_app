import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Pages/ForgetPassword.dart';
import 'package:simple_blog_app/Pages/HomePage.dart';
import 'package:simple_blog_app/Pages/SignUpPage.dart';
import 'package:simple_blog_app/Res/asset.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Res/storage_key.dart' as key;
import 'package:simple_blog_app/Res/style.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_blog_app/Widgets/widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _globalkey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  bool vis = true;

  @override
  void dispose() {
    super.dispose();
  }

  onSignInClick() async {
    setState(() {
      circular = true;
    });
    Map<String, String> data = {
      "username": _usernameController.text,
      "password": _passwordController.text,
    };
    var response = await networkHandler.post('/user/login', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> output = json.decode(response.body);
      print(output['token']);
      await storage.write(key: key.token, value: output['token']);
      setState(() {
        validate = true;
        circular = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false);
    } else {
      setState(() {
        String output = jsonDecode(response.body);
        validate = false;
        errorText = output;
        circular = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Cl.col1_pink_normal,
                ),
                child: Form(
                  key: _globalkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Asset.ic_sign_in,
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        usernameTextField("Username"),
                        SizedBox(height: 10),
                        passwordTextField("Password"),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Forgot password?",
                                    textAlign: TextAlign.center,
                                    style: St.normal1.copyWith(
                                      color: Cl.col2_pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "New user?",
                                    textAlign: TextAlign.center,
                                    style: St.normal1.copyWith(
                                      color: Cl.col1_purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        buildSignInBtn(onSignInClick),
                      ],
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

  Widget buildSignInBtn(onSignInClick) {
    return circular
        ? appCircularProgressIndicator()
        : Container(
            decoration: BoxDecoration(
              color: Cl.col2_pink,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Cl.col1_pink_weight),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSignInClick,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text(
                      "SIGN IN",
                      style: St.normal1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget usernameTextField(String label) {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          cursorColor: Cl.col2_pink,
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            fillColor: Colors.white,
            labelText: label,
            labelStyle: St.normal1.copyWith(color: Cl.col2_pink),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Cl.col2_pink,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Cl.col2_pink,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordTextField(String label) {
    return Column(
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: vis,
          cursorColor: Cl.col2_pink,
          decoration: InputDecoration(
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(
                vis ? Icons.visibility : Icons.visibility_off,
                color: Cl.col2_pink,
              ),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              },
            ),
            helperText: "Password length should have >= 8",
            helperStyle: St.normal1,
            labelText: label,
            labelStyle: St.normal1.copyWith(color: Cl.col2_pink),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Cl.col2_pink,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Cl.col2_pink,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
