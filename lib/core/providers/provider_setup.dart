import 'package:firebase_auth/firebase_auth.dart';
import 'package:mtp_live_sound/core/services/services.dart';
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
  ProxyProvider<Api, Auth>(
    update: (context, api, authService) => Auth(),
  ),
];
List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    lazy: false,
    create: (context) => Provider.of<Auth>(context, listen: false).currentUser,
  ),
/*  StreamProvider<QuerySnapshot>(
    lazy: false,
    create: (context) =>
    Provider.of<DatabaseService>(context, listen: false).posts,
  )*/
];