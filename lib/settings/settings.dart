import 'dart:async';

import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../home/home_screen.dart';
import '../settings/_about.dart';
import '../settings/_data.dart';
import '../settings/_general.dart';
import '../settings/_home.dart';
import '../settings/_theme.dart';
import '../utils/legacy.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatefulWidget {
  final String? initialPage;

  const SettingsScreen({Key? key, this.initialPage}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(appName: '', packageName: '', version: '', buildNumber: '');
  String _legacyExportPath = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      var packageInfo = await PackageInfo.fromPlatform();
      var legacyExportPath = await getLegacyPath(legacyExportFileName);

      setState(() {
        _packageInfo = packageInfo;
        _legacyExportPath = legacyExportPath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appVersion = 'v${_packageInfo.version}+${_packageInfo.buildNumber}';

    var pages = [
      NavigationPage('general', (c) => L10n.of(c).general, Icons.settings),
      NavigationPage('home', (c) => L10n.of(c).home, Icons.home),
      NavigationPage('theme', (c) => L10n.of(c).theme, Icons.format_paint),
      NavigationPage('data', (c) => L10n.of(c).data, Icons.storage),
      NavigationPage('about', (c) => L10n.of(c).about, Icons.help),
    ];

    var initialPage = pages.indexWhere((element) => element.id == widget.initialPage);
    if (initialPage == -1) {
      initialPage = 0;
    }

    return ScaffoldWithBottomNavigation(
      initialPage: initialPage,
      pages: pages,
      builder: (scrollController) {
        return [
          const SettingsGeneralFragment(),
          const SettingsHomeFragment(),
          const SettingsThemeFragment(),
          SettingsDataFragment(legacyExportPath: _legacyExportPath),
          SettingsAboutFragment(appVersion: appVersion)
        ];
      },
    );
  }
}
