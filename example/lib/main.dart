import 'package:flutter/material.dart';
import 'package:lightweight_calendar/lightweight_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: CalendarApp(
            startDate: DateTime(2022, 1, 1),
            onSelectedDate: (date) {
              print(date);
            },
            endDate: DateTime(2024, 1, 1),
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
          ),
        ));
  }
}
