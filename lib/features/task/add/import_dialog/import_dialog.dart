import 'package:flutter/material.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({
    super.key,
    required this.templatesWidgets,
  });

  final List<Widget> templatesWidgets;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Select template")),
      content: SizedBox(
        height: 300,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            children: templatesWidgets.isEmpty
                ? [
                    SizedBox(
                      height: 10,
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
      ),
    );
  }
}
