import 'package:flutter/material.dart';
import 'package:task_scheduler/features/task/edit/edit_template/edit_template.dart';
import 'package:task_scheduler/features/task/task.dart';

class TemplateCard extends StatelessWidget {
  const TemplateCard({super.key, required this.template});

  final TaskTemplate template;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4) + EdgeInsets.only(left: 10),
          title: Text(
            template.title,
            style: TextStyle(fontSize: 17),
          ),
          trailing: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (context) => EditTemplate(
                  template: template,
                ),
              );
            },
            icon: Icon(
              Icons.edit,
            ),
          ),
        ),
      ),
    );
  }
}
