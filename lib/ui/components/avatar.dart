import 'package:flutter/material.dart';
import 'package:mtp_live_sound/core/models/models.dart';
import 'package:mtp_live_sound/ui/components/components.dart';

class Avatar extends StatelessWidget {
  Avatar(
      this.user,
      );
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if ((user?.photoURL == '') || (user?.photoURL == null)) {
      return LogoGraphicHeader();
    }
    return Hero(
      tag: 'User Avatar Image',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          radius: 70.0,
          child: ClipOval(
            child: Image.network(
              user?.photoURL,
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );
  }
}