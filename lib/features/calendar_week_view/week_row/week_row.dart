import 'package:flutter/material.dart';

class WeekRow extends StatefulWidget {
  WeekRow({super.key});

  @override
  State<WeekRow> createState() => _WeekRowState();
}

class _WeekRowState extends State<WeekRow> {
  final GlobalKey key = GlobalKey();

  Offset sliderPosition = Offset(0, 0);

  final currentTime = DateTime.now();

  final day = Duration(days: 1);

  @override
  Widget build(BuildContext context) {
    final prevWeek = <Widget>[];
    final currentWeek = <Widget>[];
    final nextWeek = <Widget>[];
    // Get week start and end
    final DateTime weekStart =
        currentTime.add(day * -1 * (currentTime.weekday - 1));
    final DateTime weekEnd = weekStart.add(day * 6);

    for (DateTime curDay = weekStart;
        curDay.difference(weekEnd) <= Duration.zero;
        curDay = curDay.add(day)) {
      // Fill arrays with week days dates
      DateTime copy = curDay;
      prevWeek.add(WeekDayWidget(date: copy.add(day * -7)));
      currentWeek.add(WeekDayWidget(date: copy));
      nextWeek.add(WeekDayWidget(date: copy.add(day * 7)));
    }

    return Flexible(
      child: FractionallySizedBox(
        widthFactor: 1,
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: sliderPosition,
              child: FractionallySizedBox(
                widthFactor: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: prevWeek,
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            sliderPosition =
                                Offset(details.delta.dx + sliderPosition.dx, 0);
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          setState(() {
                            sliderPosition = Offset(300, 0);
                          });
                        },
                        onHorizontalDragCancel: () {
                          setState(() {
                            sliderPosition = Offset.zero;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: currentWeek,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: nextWeek,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WeekDayWidget extends StatelessWidget {
  const WeekDayWidget({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(CircleBorder()),
          backgroundColor: MaterialStatePropertyAll(Colors.red),
        ),
        onPressed: () {},
        child: Text(
          date.day.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
