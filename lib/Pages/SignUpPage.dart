import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Pages/HomePage.dart';
import 'package:simple_blog_app/Res/asset.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Res/storage_key.dart' as key;
import 'package:simple_blog_app/Res/style.dart';
import 'package:simple_blog_app/Widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;

  @override
  void dispose() {
    super.dispose();
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        validate = false;
        circular = false;
        errorText = "Username can't be empty";
      });
    } else {
      var response = await networkHandler.get('/user/checkusername/${_usernameController.text}');
      if (response['Status']) {
        setState(() {
          validate = false;
          errorText = "Username already taken";
          circular = false;
        });
      } else {
        validate = true;
      }
    }
  }

  onSignUpClick() async {
    setState(() {
      circular = true;
    });
    await checkUser();
    if (_globalkey.currentState.validate() && validate) {
      ///Send data to rest server
      Map<String, String> data = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      print(data);
      var responseRegister = await networkHandler.post("/user/register", data);

      //Login Logic added here
      if (responseRegister.statusCode == 200 || responseRegister.statusCode == 201) {
        Map<String, String> data = {
          "username": _usernameController.text,
          "password": _passwordController.text,
        };
        var response = await networkHandler.post("/user/login", data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> output = json.decode(response.body);
          print(output["token"]);
          await storage.write(key: key.token, value: output["token"]);
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Netwok Error")));
        }
      }
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Asset.ic_email,
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 20),
                      usernameTextField("Username"),
                      emailTextField("Email"),
                      passwordTextField("Password"),
                      SizedBox(height: 20),
                      buildSignUpBtn(onSignUpClick),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUpBtn(onSignUpClick) {
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
                onTap: onSignUpClick,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text(
                      "SIGN UP",
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
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
      ),
    );
  }

  Widget emailTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return "Email can't be empty";
              if (!value.contains("@")) return "Email is invalid";
              return null;
            },
            cursorColor: Cl.col2_pink,
            decoration: InputDecoration(
              fillColor: Colors.white,
              labelText: label,
              labelStyle: St.normal1.copyWith(color: Cl.col2_pink),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Cl.col2_pink),
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
      ),
    );
  }

  Widget passwordTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        children: [
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value.isEmpty) return "Password can't be empty";
              if (value.length < 8) return "Password length should have >= 8";
              return null;
            },
            obscureText: vis,
            cursorColor: Cl.col2_pink,
            decoration: InputDecoration(
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
      ),
    );
  }
}
