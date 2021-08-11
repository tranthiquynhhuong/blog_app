import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Pages/HomePage.dart';
import 'package:simple_blog_app/Pages/WelcomePage.dart';
import 'package:simple_blog_app/Res/asset.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Res/storage_key.dart' as key;
import 'package:simple_blog_app/Res/style.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_blog_app/Widgets/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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

  onUpdatePasswordClick() async {
    setState(() {
      circular = true;
    });
    Map<String, String> data = {"password": _passwordController.text};
    print("/user/update/${_usernameController.text}");
    var response = await networkHandler.patch("/user/update/${_usernameController.text}", data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("/user/update/${_usernameController.text}");
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => WelcomePage()), (route) => false);
      setState(() {
        circular = false;
      });
    } else {
      setState(() {
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
                          Asset.ic_forgot_pw,
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        usernameTextField("Username"),
                        SizedBox(height: 10),
                        passwordTextField("Password"),
                        SizedBox(height: 20),
                        buildSignInBtn(onUpdatePasswordClick),
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

  Widget buildSignInBtn(onClick) {
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
                onTap: onClick,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text(
                      "UPDATE PASSWORD",
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
