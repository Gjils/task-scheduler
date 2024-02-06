import 'package:flutter/material.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask(
      {super.key,
      required this.onSave,
      required this.content,
      required this.label});

  final Function onSave;
  final Widget content;
  final Widget label;

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650,
      padding:
          EdgeInsets.only(bottom: 30) + EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          widget.label,
          SizedBox(
            height: 20,
          ),
          widget.content,
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Discard",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: FilledButton(
                        onPressed: () {
                          widget.onSave();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
