import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_scheduler/pages/schedule_page/schedule_page.dart';
import 'package:task_scheduler/pages/templates_page/templates_page.dart';
import 'package:task_scheduler/features/navigation_bar/navigation_bar.dart';

import '../../state/state.dart';

class TaskSchedulerApp extends StatefulWidget {
  const TaskSchedulerApp({super.key});

  @override
  State<TaskSchedulerApp> createState() => _TaskSchedulerAppState();
}

class _TaskSchedulerAppState extends State<TaskSchedulerApp> {
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Destination> destinations = [
    Destination(
      title: "Schedule",
      icon: Icon(Icons.checklist_rounded),
      page: SchedulePage(),
    ),
    Destination(
      title: "Templates",
      icon: Icon(Icons.format_list_numbered_rounded),
      page: TemplatesPage(),
    ),
    Destination(
      title: "Settings",
      icon: Icon(Icons.settings_rounded),
      page: Placeholder(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Task Scheduler",
          theme: ThemeData(
              useMaterial3: true, colorScheme: context.watch<AppState>().theme),
          home: Scaffold(
            appBar: AppBar(title: Text(destinations[selectedIndex].title)),
            body: destinations[selectedIndex].page,
            bottomNavigationBar: AppNavigationBar(
                destinations: destinations,
                selectedIndex: selectedIndex,
                setSelectedIndex: setSelectedIndex),
          )),
    );
  }
}