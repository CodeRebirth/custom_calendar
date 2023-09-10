import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'const/string_const.dart';
import 'models/disable_date_style.dart';
import 'models/enable_date_style.dart';
import 'models/header_style.dart';

class CalendarApp extends StatefulWidget {
  final BoxDecoration? selectedDecoration;
  final BoxDecoration? todayDecoration;
  final bool Function(DateTime)? enablePredicate;
  final Function(DateTime)? onSelectedDate;
  final bool showHeader;
  final DateTime startDate;
  final DateTime endDate;
  final HeaderStyle? headerStyle;
  final EnableDateStyle enableDateStyle;
  final DisableDateStyle disableDateStyle;
  final bool swipeAnimationEnable;

  // Use an instance variable to set enablePredicate
  CalendarApp(
      {Key? key,
      this.onSelectedDate,
      this.selectedDecoration,
      this.todayDecoration,
      HeaderStyle? headerStyle,
      EnableDateStyle? enableDateStyle,
      DisableDateStyle? disableDateStyle,
      bool Function(DateTime)? enablePredicate,
      this.swipeAnimationEnable = false,
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
  late DateTime currentDate;
  DateTime? selectedDate;
  Offset? swipeStart;
  final double swipeThreshold = 50.0;
  double xOffset = 0.0; // for swipe animation purposes

  void onSelectedDateCallback(DateTime date) {
    widget.onSelectedDate!(date);
  }

  void handleSwipeStart(DragStartDetails details) {
    swipeStart = details.localPosition;
  }

  void handleSwipeEnd(DragEndDetails details) {
    if (swipeStart != null) {
      final dx = details.velocity.pixelsPerSecond.dx;

      if (dx > swipeThreshold) {
        // Swiped right
        prevMonth();
      } else if (dx < -swipeThreshold) {
        // Swiped left
        nextMonth();
      }

      swipeStart = null;
    }
  }

  void handleSwipe(DragUpdateDetails details) {
    if (details.primaryDelta! > 0) {
      // Swiped right
      prevMonth();
    } else if (details.primaryDelta! < 0) {
      // Swiped left
      nextMonth();
    }
  }

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
    onSelectedDateCallback(date);
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

        xOffset = -MediaQuery.of(context).size.width; // Slide to the left
      });

      // After the animation, reset the xOffset
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          xOffset = 0.0;
        });
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

        xOffset = MediaQuery.of(context).size.width; // Slide to the right
      });

      // After the animation, reset the xOffset
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          xOffset = 0.0;
        });
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        handleSwipeStart(details);
      },
      onHorizontalDragEnd: (details) {
        handleSwipeEnd(details);
      },
      child: AnimatedContainer(
        duration: widget.swipeAnimationEnable == true ? Duration(milliseconds: 300) : Duration(milliseconds: 0),
        transform: widget.swipeAnimationEnable == true ? Matrix4.translationValues(xOffset, 0.0, 0.0) : null,
        child: Center(
          child: ListView(shrinkWrap: true, physics: isLandscape ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(), children: [
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape ? 7 : 7, // Always set crossAxisCount to 7
                childAspectRatio: isLandscape ? 2 : 2.0,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    StringConst.instance.weekdays[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // Always set crossAxisCount to 7
                childAspectRatio: isLandscape ? 2 : 1.35, // Adjust child aspect ratio in landscape
              ),
              itemCount: 7 * 6,
              itemBuilder: (context, index) {
                final day = index + 1 - DateTime(currentDate.year, currentDate.month, 1).weekday;
                final dateTime = DateTime(currentDate.year, currentDate.month, day);
                return buildDayContainer(dateTime);
              },
            ),
          ]),
        ),
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
