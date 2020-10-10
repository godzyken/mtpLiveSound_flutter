
import 'package:flutter/material.dart';
import 'package:mtpLiveSound/core/models/post.dart';
import 'package:mtpLiveSound/core/models/user.dart';
import 'package:mtpLiveSound/ui/shared/app_colors.dart';
import 'package:mtpLiveSound/ui/shared/text_styles.dart';
import 'package:mtpLiveSound/ui/shared/ui_helpers.dart';
import 'package:mtpLiveSound/ui/widgets/comments.dart';
import 'package:provider/provider.dart';


class PostView extends StatelessWidget {
  final Post post;
  const PostView({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UIHelper.verticalSpaceLarge,
            Text(post.title, style: headerStyle),
            Text(
              'by ${Provider.of<User>(context).displayName}',
              style: TextStyle(fontSize: 9.0),
            ),
            UIHelper.verticalSpaceMedium,
            Text(post.body),
            Comments(post.id)
          ],
        ),
      ),
    );
  }
}