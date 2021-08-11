import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_blog_app/Pages/HomePage.dart';
import 'package:simple_blog_app/Res/asset.dart';
import 'package:simple_blog_app/Res/color.dart';
import 'package:simple_blog_app/Res/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_app/Widgets/widgets.dart';
import '../NetworkHandler.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  final _globalkey = GlobalKey<FormState>();
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = PickedFile(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _globalkey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            children: [
              imageProfile(),
              buildTextField(
                controller: _name,
                labelTxt: "Name",
                hintTxt: "HuongTran",
                iconData: Icons.person,
              ),
              buildTextField(
                controller: _profession,
                labelTxt: "Profession",
                hintTxt: "Fullstack developer",
                iconData: Icons.person,
              ),
              buildTextField(
                controller: _dob,
                labelTxt: "DOB",
                hintTxt: "01/01/2020",
                helperTxt: "Provide DOB on dd/mm/yyyy",
                iconData: Icons.date_range,
              ),
              buildTextField(
                controller: _title,
                labelTxt: "Title",
                hintTxt: "Mobile developer",
                iconData: Icons.title,
              ),
              buildTextField(
                controller: _about,
                labelTxt: "About",
                hintTxt: "I'm HuongTran",
                helperTxt: "Write about yourself",
                maxLine: 4,
              ),
              buildSubmitBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Center(
        child: Stack(children: <Widget>[
          CircleAvatar(
            backgroundColor: Cl.col1_pink_normal,
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? AssetImage(
                    Asset.ic_avatar_default,
                  )
                : FileImage(
                    File(_imageFile.path),
                  ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              color: Cl.col1_purple,
              iconSize: 28,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildSubmitBtn() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        if (_globalkey.currentState.validate()) {
          Map<String, String> data = {
            "name": _name.text,
            "profession": _profession.text,
            "DOB": _dob.text,
            "titleline": _title.text,
            "about": _about.text,
          };
          var response = await networkHandler.post("/profile/add", data);
          if (response.statusCode == 200 || response.statusCode == 201) {
            if (_imageFile.path != null) {
              print(_imageFile.path);
              var imageResponse = await networkHandler.patchImage("/profile/add/image", _imageFile.path);
              if (imageResponse.statusCode == 200) {
                setState(() {
                  circular = false;
                });
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
              }
            } else {
              setState(() {
                circular = false;
              });
              Navigator.of(context)
                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
            }
          } else {
            print(response.body);
            print(response.statusCode);
          }
        } else {
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Cl.col2_pink,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: circular
              ? appCircularProgressIndicator()
              : Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "Choose profile photo",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    takePhoto(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Cl.col2_pink,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Camera",
                          style: St.title_col2_pink,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Cl.col2_pink,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Gallery",
                          style: St.title_col2_pink,
                        ),
                      ],
                    ),
                  ),
                ),
              ])
        ],
      ),
    );
  }

  Widget buildTextField({
    TextEditingController controller,
    String labelTxt,
    String hintTxt,
    String helperTxt,
    IconData iconData,
    int maxLine,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value.isEmpty) return "$labelTxt can't be empty";

          return null;
        },
        maxLines: maxLine ?? 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Cl.col2_pink,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Cl.col2_pink,
            width: 2,
          )),
          prefixIcon: iconData != null
              ? Icon(
                  iconData,
                  color: Cl.col2_pink,
                )
              : null,
          labelText: "$labelTxt",
          labelStyle: TextStyle(color: Cl.col2_pink),
          helperText: helperTxt ?? "$labelTxt can't be empty",
          hintText: "$hintTxt",
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}
