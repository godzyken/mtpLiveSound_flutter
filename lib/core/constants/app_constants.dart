import 'package:mtp_live_sound/ui/pages/pages.dart';
import 'package:mtp_live_sound/ui/widgets/widgets.dart';
import 'package:mtp_live_sound/ui/ui.dart';
import 'package:mtp_live_sound/ui/auth/auth.dart';
import 'package:get/get.dart';

class RoutePaths {
  RoutePaths._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/signin', page: () => SignInUI()),
    GetPage(name: '/signup', page: () => SignUpUI()),
    GetPage(name: '/home', page: () => HomeUI()),
    GetPage(name: '/settings', page: () => SettingsUI()),
    GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
/*    GetPageRoute(routeName: '/landing', page: () => LandingPage()),
    GetPageRoute(routeName: '/home/me', page: () => MyHomePage()),
    GetPageRoute(routeName: '/login', page: () => LoginPage()),
    GetPageRoute(routeName: '/post', page: () => PostView()),
    GetPageRoute(routeName: '/posts', page: () => PostListItem()),*/
  ];
}