import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_blog_app/Pages/HomePage.dart';
import 'package:simple_blog_app/Pages/WelcomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_blog_app/Res/storage_key.dart' as key;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await storage.read(key: key.token);
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      page = WelcomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}
