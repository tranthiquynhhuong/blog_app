import 'package:flutter/material.dart';
import 'package:simple_blog_app/Model/addBlogModels.dart';
import 'package:simple_blog_app/NetworkHandler.dart';
import 'package:simple_blog_app/Res/style.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({Key key, this.addBlogModel, this.networkHandler}) : super(key: key);

  final AddBlogModel addBlogModel;
  final NetworkHandler networkHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "@" + addBlogModel.username,
              style: St.username_profile,
            ),
            Text(
              addBlogModel.title,
              style: St.title_main_profile,
            ),
            SizedBox(height: 5),
            Text(
              addBlogModel.body,
              style: St.subTitle_main_profile,
            ),
            SizedBox(height: 5),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: networkHandler.getImage(addBlogModel.id),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
