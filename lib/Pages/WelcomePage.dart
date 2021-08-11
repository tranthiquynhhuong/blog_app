import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_blog_app/Pages/SignInPage.dart';
import 'package:simple_blog_app/Pages/SignUpPage.dart';
import 'package:simple_blog_app/Res/asset.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Res/style.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'SignUpPage.dart';
import 'package:http/http.dart' as http;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> animation;
  bool isLogin = false;
  Map data;

  final facebookLogin = FacebookLogin();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    animation = Tween<Offset>(
      begin: Offset(0.0, 0.8),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onSignInClick() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  onEmailClick() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  onFBLogin() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        Uri uri = Uri.parse(
            "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token");
        final response = await http.get(uri);
        final data1 = json.decode(response.body);
        print(data);
        setState(() {
          isLogin = true;
          data = data1;
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          isLogin = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLogin = false;
        });
        break;
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: SlideTransition(
                    position: animation,
                    child: Column(
                      children: [
                        Image.asset(
                          Asset.ic_blog,
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          "Great story for great people",
                          textAlign: TextAlign.center,
                          style: St.title2.copyWith(color: Cl.col2_pink),
                        ),
                        SizedBox(height: 20),
                        buildLoginBtn(path: Asset.ic_gg, title: "Sign up with Google", onClick: null),
                        buildLoginBtn(path: Asset.ic_fb, title: "Sign up with Facebook", onClick: onFBLogin),
                        buildLoginBtn(
                            path: Asset.ic_email, title: "Sign up with Email", onClick: onEmailClick),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              textAlign: TextAlign.center,
                              style: St.normal1.copyWith(color: Cl.col2_pink),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onSignInClick,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "SIGN IN",
                                    textAlign: TextAlign.center,
                                    style: St.normal1.copyWith(
                                      color: Cl.col2_pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget buildLoginBtn({String path, String title, onClick}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Cl.col1_pink_weight),
        ),
        width: MediaQuery.of(context).size.width - 30,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onClick,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(
                      path,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 20),
                    Text(
                      title,
                      style: St.normal1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
