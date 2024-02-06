import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class TemplatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final templates = context.watch<AppState>().templates;
    final templatesWidgets = templates
        .map((template) => ListTile(title: Text(template.title)))
        .cast<Widget>()
        .toList();
    return Scaffold(
      body: ListView(
        children: templatesWidgets,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => AddTemplate(),
        ),
        label: Text("New template"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
