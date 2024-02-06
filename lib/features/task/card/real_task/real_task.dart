import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/task/edit/edit_real/edit_real.dart';
import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class RealTaskCard extends StatelessWidget {
  const RealTaskCard({super.key, required this.task});

  final TaskReal task;

  @override
  Widget build(BuildContext context) {
    final toggleDone = context.watch<AppState>().toggleDone;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4),
          leading: IconButton(
            onPressed: () {
              toggleDone(task);
            },
            isSelected: task.isDone,
            selectedIcon: Icon(
              Icons.check_circle_outline_rounded,
              size: 32,
            ),
            icon: Icon(
              Icons.radio_button_unchecked_rounded,
              size: 32,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(fontSize: 17),
          ),
          trailing: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (context) => EditRealTask(task: task),
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
