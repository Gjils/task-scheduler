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
      title: Center(
          child: Text(
        "Select template",
        style: TextStyle(fontSize: 18),
      )),
      content: SizedBox(
        height: 300,
        width: 300,
        child: templatesWidgets.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "There are no templates\nTry adding new",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: templatesWidgets,
                ),
              ),
      ),
    );
  }
}
