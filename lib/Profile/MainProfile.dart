import 'package:flutter/material.dart';
import 'package:simple_blog_app/Blog/Blogs.dart';
import 'package:simple_blog_app/Model/profileModel.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Res/style.dart';
import 'package:simple_blog_app/Widgets/widgets.dart';

class MainProfile extends StatefulWidget {
  MainProfile({Key key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: circular
          ? centerAppCircularProgressIndicator()
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("About", profileModel.about),
                otherDetails("Name", profileModel.name),
                otherDetails("Profession", profileModel.profession),
                otherDetails("DOB", profileModel.DOB),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(height: 20),
                Blogs(
                  url: "/blogPost/getOwnBlog",
                ),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage("${profileModel.username}"),
            ),
          ),
          Text(
            "${profileModel.username ?? "-"}",
            style: St.username_profile,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${profileModel.titleline ?? "-"}",
            style: St.subTitle_main_profile,
          ),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: St.title_main_profile,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${value ?? "-"}",
            style: St.subTitle_main_profile,
          )
        ],
      ),
    );
  }
}
