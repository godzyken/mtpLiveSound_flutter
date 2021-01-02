import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtp_live_sound/core/services/sign_in.dart';
import 'package:mtp_live_sound/ui/pages/login_page.dart';
import 'package:mtp_live_sound/ui/shared/app_colors.dart';
import 'package:mtp_live_sound/core/viewmodels/views/home_model.dart';


import 'base_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return BasePage<HomeModel>(
      builder: (context, model, child) => new Scaffold(
        extendBody: true,
        appBar: new AppBar(
          title: new Text('MTP live App'),
        ),
        backgroundColor: backgroundColor,
        body: Container(
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 200.0,
                        child: StreamBuilder<User>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (BuildContext context,
                              AsyncSnapshot<User> asyncSnapshot) {
                            if (asyncSnapshot.hasError) {
                              return Text('Something went wrong happen');
                            }

                            if (!asyncSnapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (asyncSnapshot.connectionState ==
                                ConnectionState.active) {
                              var data = asyncSnapshot.data;
                              if (data.isAnonymous) {
                                return Text(
                                  "Tenant ID : ${data.uid}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              } else {
                                return Text(
                                  "Display Name : ${data.displayName}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              }
                            }
                            return Text('loading...');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 200.0,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: posts.snapshots(includeMetadataChanges: true),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            if (!snapshot.hasData) {
                              return Text("No data");
                            }
                            return new ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return new ListTile(
                                  title: new Text(document.data()['title']),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
