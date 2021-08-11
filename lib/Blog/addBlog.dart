import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_app/CustomWidget/OverlayCard.dart';
import 'package:simple_blog_app/Model/addBlogModels.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Pages/HomePage.dart';
import 'package:simple_blog_app/Res/color.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({Key key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  IconData iconphoto = Icons.image;
  ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  NetworkHandler networkHandler = NetworkHandler();

  void takeCoverPhoto() async {
    final coverPhoto = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = PickedFile(coverPhoto.path);
      iconphoto = Icons.check_box;
    });
  }

  Future<void> onAddBlogClick() async {
    if (_imageFile != null && _globalkey.currentState.validate()) {
      AddBlogModel addBlogModel = AddBlogModel(body: _body.text, title: _title.text);
      var response = await networkHandler.post1("/blogPost/add", addBlogModel.toJson());
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        String id = json.decode(response.body)["data"];
        var imageResponse = await networkHandler.patchImage("/blogPost/add/coverImage/$id", _imageFile.path);
        print(imageResponse.statusCode);
        if (imageResponse.statusCode == 200 || imageResponse.statusCode == 201) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Cl.col2_pink,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_imageFile.path != null && _globalkey.currentState.validate()) {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => OverlayCard(
                        imagefile: _imageFile,
                        title: _title.text,
                      )),
                );
              }
            },
            child: Text(
              "Preview",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 20,
            ),
            addButton(),
            // addButton(),
          ],
        ),
      ),
    );
  }

  Widget addButton() {
    return Center(
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: Cl.col2_pink,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onAddBlogClick();
            },
            child: Center(
              child: Text(
                "Add Blog",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey.shade500),
          labelStyle: TextStyle(color: Cl.col2_pink),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Cl.col2_pink,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Cl.col2_pink,
            width: 2,
          )),
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color: Cl.col2_pink,
            ),
            onPressed: takeCoverPhoto,
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey.shade500),
          labelStyle: TextStyle(color: Cl.col2_pink),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Cl.col2_pink,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Cl.col2_pink,
            width: 2,
          )),
          labelText: "Provide body your blog",
        ),
        maxLines: null,
      ),
    );
  }
}
