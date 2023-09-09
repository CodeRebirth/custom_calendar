# Lightweight Calendar Flutter Package

Lightweight Calendar is a Flutter package that provides an easy-to-use calendar widget for your mobile app. It allows you to display and interact with a calendar, making it simple to select dates, view months, and customize the appearance to match your app's design.

LightWeight Calendar Widget

## Features

* Display a calendar with selectable dates.
* Customize date selection and appearance.
* Easily navigate between months.
* Enable predicate to make which date should be enable or not

## Installation
To use the Lightweight Calendar package, add it to your pubspec.yaml file:

```yaml
dependencies:
  lightweight_calendar: ^1.0.0
```

### Basic setup

*The complete example is available [here](https://github.com/CodeRebirth/lightweight_calendar).*


**TableCalendar** requires you to provide `startDate`, `endDate`

```dart
CalendarApp(
  startDate: DateTime(2010, 1, 1),
  endDate: DateTime(2030, 1, 1),
);
```

## Customization
You can customize the appearance and behavior of the calendar by providing optional parameters such as selectedDecoration, todayDecoration, and more. Refer to the package documentation for a full list of customization options.

## Callbacks
The CalendarApp widget provides callbacks for handling date selection and navigation. You can use these callbacks to perform actions when a date is selected or when the user navigates between months.

## Documentation
For detailed documentation and examples, visit the official documentation.

## License
This package is distributed under the BSD 3-Clause License. See the LICENSE file for more information.

## Issues and Contributions
If you encounter any issues with the package or would like to contribute, please visit the GitHub repository.

We welcome your feedback and contributions to make Simple Calendar even better!