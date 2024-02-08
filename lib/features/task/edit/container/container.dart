import 'package:flutter/material.dart';

class EditContainer extends StatefulWidget {
  const EditContainer(
      {super.key,
      required this.onSave,
      required this.onDelete,
      required this.content,
      required this.label});

  final Function onSave;
  final Function onDelete;
  final Widget content;
  final Widget label;

  @override
  State<EditContainer> createState() => _EditContainerState();
}

class _EditContainerState extends State<EditContainer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(theme.error),
                                    side: MaterialStateProperty.all(
                                        BorderSide(color: theme.error))),
                                onPressed: () {
                                  widget.onDelete();
                                },
                                child: Text("Delete"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: FractionallySizedBox(
                              widthFactor: .95,
                              child: SizedBox(
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
                            ),
                          ),
                          Flexible(
                            child: FractionallySizedBox(
                              widthFactor: .95,
                              child: SizedBox(
                                height: 50,
                                child: FilledButton(
                                  onPressed: () {
                                    widget.onSave();
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
