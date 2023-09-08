import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarApp(),
    );
  }
}

class CalendarApp extends StatefulWidget {
  final BoxDecoration? selectedDecoration;
  final BoxDecoration? todayDecoration;

  const CalendarApp({
    Key? key,
    this.todayDecoration,
    this.selectedDecoration,
  }) : super(key: key);

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  final List weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  DateTime currentDate = DateTime.now();
  DateTime? selectedDate;

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day && a.month == currentDate.month;
  }

  void onSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void nextMonth() {
    setState(() {
      if (currentDate.month == DateTime.december) {
        currentDate = DateTime(currentDate.year + 1, DateTime.january);
      } else {
        currentDate = DateTime(currentDate.year, currentDate.month + 1);
      }
    });
  }

  void prevMonth() {
    setState(() {
      if (currentDate.month == DateTime.january) {
        currentDate = DateTime(currentDate.year - 1, DateTime.december);
      } else {
        currentDate = DateTime(currentDate.year, currentDate.month - 1);
      }
    });
  }

  int daysInMonth(DateTime date) {
    final beginningOfNextMonth = DateTime(date.year, date.month + 1, 1);
    final endOfThisMonth = beginningOfNextMonth.subtract(const Duration(days: 1));
    return endOfThisMonth.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Calendar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: prevMonth,
              ),
              Text(
                DateFormat.yMMM().format(currentDate),
                style: const TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: nextMonth,
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 2),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  weekday[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.3,
              crossAxisCount: 7,
            ),
            itemCount: DateTime.daysPerWeek * 6,
            itemBuilder: (context, index) {
              final day = index + 1 - currentDate.weekday;
              final dateTime = DateTime(currentDate.year, currentDate.month, day);
              return buildDayContainer(dateTime);
            },
          )
        ],
      ),
    );
  }

  Widget buildDayContainer(DateTime dateTime) {
    final day = dateTime.day;
    final isToday = isSameDay(dateTime, DateTime.now());
    final isSelected = isSameDay(selectedDate, dateTime);
    final isWithinCurrentMonth = dateTime.month == currentDate.month;

    return isToday
        ? GestureDetector(
            onTap: () => onSelectedDate(dateTime),
            child: Center(
              child: Container(
                height: 30,
                width: 30,
                decoration: isSelected
                    ? widget.selectedDecoration ?? const BoxDecoration(shape: BoxShape.circle, color: Colors.blue)
                    : widget.todayDecoration ?? BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue)),
                alignment: Alignment.center,
                child: Text(
                  isWithinCurrentMonth ? day.toString() : ' ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : isSelected
            ? GestureDetector(
                onTap: () => onSelectedDate(dateTime),
                child: Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: widget.selectedDecoration ?? const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                    alignment: Alignment.center,
                    child: Text(
                      isWithinCurrentMonth ? day.toString() : ' ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => onSelectedDate(dateTime),
                child: Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      isWithinCurrentMonth ? day.toString() : ' ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
  }
}