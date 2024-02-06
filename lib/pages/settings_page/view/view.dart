import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/state/state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeIsDark = context.watch<AppState>().themeIsDark;
    var setTheme = context.watch<AppState>().setTheme;
    return ListView(
      children: [
        SwitchListTile(
          value: themeIsDark,
          onChanged: setTheme,
          title: Text("Dark Theme"),
          secondary: Icon(Icons.dark_mode_outlined),
        )
      ],
    );
  }
}
