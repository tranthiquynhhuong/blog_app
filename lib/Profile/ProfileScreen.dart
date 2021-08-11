import 'package:flutter/material.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Profile/CreateProfile.dart';
import 'package:simple_blog_app/Profile/MainProfile.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  Widget page = centerAppCircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    if (response["status"] == true) {
      setState(() {
        page = MainProfile();
      });
    } else {
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: page),
    );
  }

  Widget showProfile() {
    return Center(
      child: Text("Profile data is avalable"),
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap to button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Cl.col2_pink,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateProfile()),
              )
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Cl.col1_purple,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "Add Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
