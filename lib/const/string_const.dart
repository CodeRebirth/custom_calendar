class StringConst {
  // Private constructor to prevent external instantiation
  StringConst._private();

  // Singleton instance
  static final StringConst _instance = StringConst._private();

  // Getter to access the singleton instance
  static StringConst get instance => _instance;

  final List<String> weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
}
