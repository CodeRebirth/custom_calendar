import 'package:flutter/material.dart';
import 'package:simple_calendar/simple_calendar.dart';

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
          endDate: DateTime(2024, 1, 1),
          startDate: DateTime(2022, 1, 1),
          enablePredicate: (date) {
            if (date.isAfter(DateTime.now())) {
              return true;
            } else {
              if (checkSameDay(date, DateTime.now())) {
                return true;
              }
              return false;
            }
          },
        ));
  }
}
