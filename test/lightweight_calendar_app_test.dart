import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightweight_calendar/lightweight_calendar_app.dart';

void main() {
  testWidgets('CalendarApp widget test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarApp(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ));

    // Verify that the CalendarApp widget is rendered.
    expect(find.byType(CalendarApp), findsOneWidget);
  });
  testWidgets('CalendarApp displays the header when showHeader is true', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarApp(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
          showHeader: true,
        ),
      ),
    ));

    final headerRowFinder = find.byType(Row);

    final monthTextFinder = find.descendant(
      of: headerRowFinder,
      matching: find.byType(Text),
    );

    expect(monthTextFinder, findsOneWidget);
  });

  testWidgets('CalendarApp does not display the header when showHeader is false', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarApp(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
          showHeader: false,
        ),
      ),
    ));

    // Find the header Row widget
    final headerRowFinder = find.byType(Row);

    // Verify that the header Row widget is not found when showHeader is false
    expect(headerRowFinder, findsNothing);
  });

  testWidgets('CalendarApp can select a date', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CalendarApp(
          onSelectedDate: (date) {
            print(date);
          },
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 12, 31),
        ),
      ),
    ));

    // Find the date cell corresponding to the selected date
    final selectedDateCellFinder = find.text('15'); // Update with the actual day of the selected date

    // Tap on the selected date cell
    await tester.tap(selectedDateCellFinder);
    await tester.pump();

    // Find the selected date cell again after the tap
    final selectedDateText = tester.widget<Text>(selectedDateCellFinder);

    // Verify that the selected date cell text has a specific style (color)
    final selectedDateTextStyle = selectedDateText.style;
    print(selectedDateTextStyle);

    // You can add assertions based on the expected text style
    expect(selectedDateTextStyle?.fontSize, equals(14.0));
  });
}
