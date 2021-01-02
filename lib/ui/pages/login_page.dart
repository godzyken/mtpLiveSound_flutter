import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mtp_live_sound/core/viewmodels/views/login_view_model.dart';
import 'package:mtp_live_sound/ui/shared/app_colors.dart';
import 'package:mtp_live_sound/ui/shared/ui_helpers.dart';
import 'package:mtp_live_sound/ui/widgets/busy_button.dart';
import 'package:mtp_live_sound/ui/widgets/google_login_button.dart';
import 'package:mtp_live_sound/ui/widgets/input_field.dart';
import 'package:mtp_live_sound/ui/widgets/text_link.dart';
import 'package:provider/provider.dart';

import 'base_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BasePage<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      builder: (context, model, child) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Login'),
          ),
          backgroundColor: backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    SizedBox(
                      height: 150,
                      //child: Image.asset('assets/images/title.png',),
                      child: CachedNetworkImage(
                        imageUrl: "http://via.placeholder.com/350x150",
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.red, BlendMode.colorBurn)
                                ),
                              ),
                            ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    InputField(
                      placeholder: 'Email',
                      onSaved: (String email) {
                        var res = model.email;
                        if (res != null) {
                          print('WAzizit right now: $res');
                          return res.toString();
                        }
                      },
                      controller: emailController,
                    ),
                    UIHelper.verticalSpaceSmall,
                    InputField(
                      placeholder: 'Password',
                      onSaved: (String password) {
                        model.password = password.isNotEmpty.toString();
                      },
                      password: true,
                      controller: passwordController,
                    ),
                    UIHelper.verticalSpaceMedium,
                    Expanded(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          BusyButton(
                            title: 'Login',
                            busy: model.state,
                            onPressed: () async {
                              var loginSuccess = await model.login();
                          if (loginSuccess != null) {
                            print(
                                'Wats happen to login with mail : $loginSuccess');
                            Navigator.pushNamed(context, 'home');
                          } else {
                            return 'Error for that field';
                          }
                        },
                          ),

                          BusyButton(
                            title: 'Visit',
                            busy: model.state,
                            onPressed: () async {
                              var loginSuccess = await model.ghostMode();
                              if (loginSuccess != null) {
                                Navigator.pushNamed(context, 'home');
                              } else {
                                return 'Error for that field';
                              }
                            },
                          ),
                          //Test OK
                          GoogleLoginButton(),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpaceMedium,
                    TextLink(
                      'Create an Account if you\'re new.',
                      onPressed: () async {
                        var currentUserA = model.createUserWithCredential;
                        if (currentUserA != null) {
                          print('Wats happen to CurrentUser : $currentUserA');
                          Navigator.pushNamed(context, 'sign');
                        } else {
                          return 'Error for that field';
                        }
                      },
                    )
                  ],
                ),
              )),
    );
  }
}
