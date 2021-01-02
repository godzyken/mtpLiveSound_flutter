import 'package:flutter/material.dart';
import 'package:mtp_live_sound/core/constants/app_constants.dart';
import 'package:mtp_live_sound/core/models/post.dart';
import 'package:mtp_live_sound/ui/pages/home_page.dart';
import 'package:mtp_live_sound/ui/pages/landing_page.dart';
import 'package:mtp_live_sound/ui/pages/login_page.dart';
import 'package:mtp_live_sound/ui/pages/post_view.dart';
import 'package:mtp_live_sound/ui/pages/signin_page.dart';
import 'package:mtp_live_sound/ui/widgets/postlist_item.dart';


const String initialRoute = "/";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Landing:
        return MaterialPageRoute(builder: (_) => LandingPage());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RoutePaths.SignIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case RoutePaths.Post:
        var post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => PostView(post: post));
      case RoutePaths.PostListItem:
        return MaterialPageRoute(builder: (_) => PostListItem());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
