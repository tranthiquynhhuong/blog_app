import 'package:flutter/material.dart';
import 'package:simple_blog_app/Blog/Blogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Blogs(
          url: "/blogPost/getOtherBlog",
        ),
      ),
    );
  }
}
