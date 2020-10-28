import 'package:flutter/material.dart';
import 'package:mtpLiveSound/core/viewmodels/views/login_view_model.dart';
import 'package:mtpLiveSound/ui/shared/app_colors.dart';
import 'package:mtpLiveSound/ui/shared/ui_helpers.dart';
import 'package:mtpLiveSound/ui/widgets/busy_button.dart';
import 'package:mtpLiveSound/ui/widgets/google_login_button.dart';
import 'package:mtpLiveSound/ui/widgets/input_field.dart';
import 'package:mtpLiveSound/ui/widgets/text_link.dart';
import 'package:provider/provider.dart';

import 'base_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePage<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      builder: (context, model, child) => Scaffold(
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
                  child: Image.asset('assets/images/title.png',),
                ),
                InputField(
                  placeholder: 'Email',
                  onSaved: (String email) {
                    model.email = email.isNotEmpty.toString();
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
                          var loginSuccess = model.login;
                          if (loginSuccess != null) {
                            Navigator.pushNamed(context, 'home');
                          }
                        },
                      ),

                      BusyButton(
                        title: 'Visit',
                        busy: model.state,
                        onPressed: () async {
                          var loginSuccess = model.ghostMode;
                          if (loginSuccess != null) {
                            Navigator.pushNamed(context, 'home');
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
                      Navigator.pushNamed(context, 'sign');
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
