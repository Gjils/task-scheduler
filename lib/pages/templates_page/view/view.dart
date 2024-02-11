import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class TemplatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final templates = context.watch<AppState>().templates;
    final templatesWidgets = templates
        .map((template) => TemplateCard(template: template))
        .cast<Widget>()
        .toList();
    templatesWidgets.add(SizedBox(
      height: 80,
    ));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: templates.isEmpty
              ? [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "There are no templates\nTry adding new",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ]
              : templatesWidgets,
        ),
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
