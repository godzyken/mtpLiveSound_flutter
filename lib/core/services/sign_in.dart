import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

//Test OK
Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}
