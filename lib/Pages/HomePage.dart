import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_blog_app/Blog/addBlog.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Pages/WelcomePage.dart';
import 'package:simple_blog_app/Profile/ProfileScreen.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Res/style.dart';
import 'package:simple_blog_app/Screen/HomeScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  String username = "username";

  @override
  initState() {
    super.initState();
    checkProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    if (response["status"] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response["username"]),
        );
        username = response["username"];
      });
    } else {
      setState(() {
        profilePhoto = Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      });
    }
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  // Text("@$username"),
                  Center(
                    child: Text(
                      "@$username",
                      style: St.title_drawer.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildDrawerItem("All Post", Icons.launch, null),
            buildDrawerItem("New Story", Icons.add, null),
            buildDrawerItem("Settings", Icons.settings, null),
            buildDrawerItem("Feedback", Icons.feedback, null),
            Divider(),
            ListTile(
              title: Text(
                "Logout",
                style: St.title_drawer.copyWith(color: Cl.redPri1),
              ),
              trailing: Icon(
                Icons.power_settings_new,
                color: Cl.redPri1,
              ),
              onTap: logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Cl.col2_pink,
        title: Text("${titleString[currentState]}"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Cl.col2_pink,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 32),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Cl.col1_pink_normal,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    currentState == 0 ? Icons.home : Icons.home_outlined,
                    color: Cl.col2_pink,
                  ),
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(
                    currentState == 1 ? Icons.person : Icons.person_outline,
                    color: Cl.col2_pink,
                  ),
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  Widget buildDrawerItem(String title, IconData iconData, Function onTap) {
    return ListTile(
      title: Text(
        "$title",
        style: St.title_drawer,
      ),
      trailing: Icon(
        iconData,
        color: Cl.col2_pink,
      ),
      onTap: onTap,
    );
  }
}
