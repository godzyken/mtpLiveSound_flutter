import 'package:firebase_auth/firebase_auth.dart';
import 'package:mtpLiveSound/core/services/api.dart';
import 'package:mtpLiveSound/core/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];
List<SingleChildWidget> independentServices = [
  Provider.value(value: Api()),
];
List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthService>(
    update: (context, api, authService) => AuthService(api: api),
  ),
];
List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    lazy: false,
    create: (context) =>
    Provider.of<AuthService>(context, listen: false).currentUser,
  ),
/*  StreamProvider<QuerySnapshot>(
    lazy: false,
    create: (context) =>
    Provider.of<DatabaseService>(context, listen: false).posts,
  )*/
];