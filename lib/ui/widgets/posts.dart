import 'package:flutter/material.dart';
import 'package:mtpLiveSound/core/constants/app_constants.dart';
import 'package:mtpLiveSound/core/viewmodels/widgets/posts_model.dart';
import 'package:mtpLiveSound/ui/pages/base_page.dart';
import 'package:mtpLiveSound/ui/widgets/postlist_item.dart';
import 'package:provider/provider.dart';


class Posts extends StatelessWidget {
  const Posts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage<PostsModel>(
        model: PostsModel(api: Provider.of(context)),
        onModelReady: (model) => model.fetchPostsAsStream(),
        builder: (context, model, child) => model.state
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: model.posts.length,
                itemBuilder: (context, i) => PostListItem(
                  post: model.posts[i],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.Post,
                      arguments: model.posts[i],
                    );
                  },
                ),
              ));
  }
}