import 'package:flutter/material.dart';
import 'package:simple_blog_app/Blog/Blog.dart';
import 'package:simple_blog_app/CustomWidget/BlogCard.dart';
import 'package:simple_blog_app/Model/addBlogModels.dart';
import 'package:simple_blog_app/Model/superModel.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Res/style.dart';

class Blogs extends StatefulWidget {
  Blogs({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (contex) => Blog(
                                  addBlogModel: item,
                                  networkHandler: networkHandler,
                                ),
                              ),
                            );
                          },
                          child: BlogCard(
                            addBlogModel: item,
                            networkHandler: networkHandler,
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ))
                .toList(),
          )
        : Center(
            child: Text(
              "We don't have any Blog yet :(",
              style: St.empty_notice,
            ),
          );
  }
}
