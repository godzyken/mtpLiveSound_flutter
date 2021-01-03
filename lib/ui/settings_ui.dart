import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtp_live_sound/core/constants/constants.dart';
import 'package:mtp_live_sound/core/controllers/controllers.dart';
import 'package:mtp_live_sound/core/models/models.dart';
import 'package:mtp_live_sound/localizations.dart';
import 'package:mtp_live_sound/ui/auth/auth.dart';
import 'package:mtp_live_sound/ui/components/components.dart';

class SettingsUI extends StatelessWidget {
  //final LanguageController languageController = LanguageController.to;
  //final ThemeController themeController = ThemeController.to;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(labels.settings.title),
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return ListView(
      children: <Widget>[
        languageListTile(context),
        themeListTile(context),
        ListTile(
            title: Text(labels.settings.updateProfile),
            trailing: RaisedButton(
              onPressed: () async {
                Get.to(UpdateProfileUI());
              },
              child: Text(
                labels.settings.updateProfile,
              ),
            )),
        ListTile(
          title: Text(labels.settings.signOut),
          trailing: RaisedButton(
            onPressed: () {
              AuthController.to.signOut();
            },
            child: Text(
              labels.settings.signOut,
            ),
          ),
        )
      ],
    );
  }

  languageListTile(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return GetBuilder<LanguageController>(
      builder: (controller) => ListTile(
        title: Text(labels.settings.language),
        trailing: DropdownPicker(
          menuOptions: Globals.languageOptions,
          selectedOption: controller.currentLanguage,
          onChanged: (value) async {
            await controller.updateLanguage(value);
            Get.forceAppUpdate();
          },
        ),
      ),
    );
  }

  themeListTile(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(
          key: "system",
          value: labels.settings.system,
          icon: Icons.brightness_4),
      MenuOptionsModel(
          key: "light",
          value: labels.settings.light,
          icon: Icons.brightness_low),
      MenuOptionsModel(
          key: "dark", value: labels.settings.dark, icon: Icons.brightness_3)
    ];
    return GetBuilder<ThemeController>(
      builder: (controller) => ListTile(
        title: Text(labels.settings.theme),
        trailing: SegmentedSelector(
          selectedOption: controller.currentTheme,
          menuOptions: themeOptions,
          onValueChanged: (value) {
            controller.setThemeMode(value);
          },
        ),
      ),
    );
  }
}
