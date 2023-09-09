import 'package:custom_calender/models/disable_date_style.dart';
import 'package:custom_calender/models/enable_date_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:custom_calender/global_utils.dart';
import 'models/header_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarApp(
        showHeader: true,
        endDate: DateTime(2024, 1, 1),
        startDate: DateTime(2022, 1, 1),
        headerStyle: HeaderStyle(
          headerTitleTextStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        enablePredicate: (date) {
          if (date.isBefore(DateTime.now())) {
            if (checkSameDay(date, DateTime.now())) {
              return true;
            }
            return false;
          }
          return true;
        },
      ),
    );
  }
}

class CalendarApp extends StatefulWidget {
  final BoxDecoration? selectedDecoration;
  final BoxDecoration? todayDecoration;
  final bool Function(DateTime)? enablePredicate;
  final bool showHeader;
  final DateTime startDate;
  final DateTime endDate;
  final HeaderStyle? headerStyle;
  final EnableDateStyle enableDateStyle;
  final DisableDateStyle disableDateStyle;

  // Use an instance variable to set enablePredicate
  CalendarApp(
      {Key? key,
      this.selectedDecoration,
      this.todayDecoration,
      HeaderStyle? headerStyle,
      EnableDateStyle? enableDateStyle,
      DisableDateStyle? disableDateStyle,
      bool Function(DateTime)? enablePredicate,
      this.showHeader = true,
      required this.startDate,
      required this.endDate})
      : enablePredicate = enablePredicate ?? ((date) => true),
        headerStyle = headerStyle ?? HeaderStyle.normal(),
        disableDateStyle = disableDateStyle ?? DisableDateStyle.defaultTextStyle(),
        enableDateStyle = enableDateStyle ?? EnableDateStyle.defaultTextStyle(), // Set a default value if not provided
        super(key: key);

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  final List weekday = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  late DateTime currentDate;
  DateTime? selectedDate;
  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

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
    if (currentDate.isBefore(widget.endDate)) {
      setState(() {
        if (currentDate.month == DateTime.december) {
          currentDate = DateTime(currentDate.year + 1, DateTime.january);
        } else {
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }
      });
    }
  }

  void prevMonth() {
    if (currentDate.isAfter(widget.startDate)) {
      setState(() {
        if (currentDate.month == DateTime.january) {
          currentDate = DateTime(currentDate.year - 1, DateTime.december);
        } else {
          currentDate = DateTime(currentDate.year, currentDate.month - 1);
        }
      });
    }
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
        title: const Text('Simple Fast Calender'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (widget.showHeader)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: widget.headerStyle!.leftChevron ?? HeaderStyle.normal().leftChevron!,
                  onPressed: prevMonth,
                ),
                Text(
                  DateFormat.yMMM().format(currentDate),
                  style: widget.headerStyle!.headerTitleTextStyle,
                ),
                IconButton(
                  icon: widget.headerStyle!.rightChevron ?? HeaderStyle.normal().rightChevron!,
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
              childAspectRatio: 1.35,
              crossAxisCount: 7,
            ),
            itemCount: DateTime.daysPerWeek * 6,
            itemBuilder: (context, index) {
              final day = index + 1 - DateTime(currentDate.year, currentDate.month, 1).weekday;
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
    final isDateSelectable = widget.enablePredicate!(dateTime);

    BoxDecoration? decoration;

    if (isSelected) {
      decoration = widget.selectedDecoration ?? const BoxDecoration(shape: BoxShape.circle, color: Colors.blue);
    } else if (isToday) {
      decoration = widget.todayDecoration ?? BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue));
    } else {
      decoration = const BoxDecoration(); // No decoration for unselectable dates
    }

    return GestureDetector(
      onTap: () {
        if (!isDateSelectable) {
          return;
        }
        onSelectedDate(dateTime);
      },
      child: Center(
        child: Container(
          height: 30,
          width: 30,
          decoration: decoration,
          alignment: Alignment.center,
          child: Text(isWithinCurrentMonth ? day.toString() : ' ', style: isDateSelectable ? widget.enableDateStyle.enableDateTextStyle : widget.disableDateStyle.disableDateTextStyle),
        ),
      ),
    );
  }
}
