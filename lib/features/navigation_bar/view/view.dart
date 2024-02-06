import 'package:flutter/material.dart';

import '../model/model.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar(
      {super.key,
      required this.selectedIndex,
      required this.destinations,
      required this.setSelectedIndex});

  final int selectedIndex;
  final List<Destination> destinations;
  final void Function(int) setSelectedIndex;

  @override
  Widget build(BuildContext context) {
    List<Widget> navigationLitems = destinations
        .map(
          (Destination destination) => NavigationDestination(
            icon: destination.icon,
            label: destination.title,
          ),
        )
        .cast<Widget>()
        .toList();

    return NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: setSelectedIndex,
        destinations: navigationLitems
        // destinations: <Widget>[
        //   NavigationDestination(
        //     icon: Icon(Icons.checklist_rounded),
        //     label: "Schedule",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Icons.format_list_numbered_rounded),
        //     label: "Tasks",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Icons.settings_rounded),
        //     label: "Settings",
        //   ),
        // ],
        );
  }
}
