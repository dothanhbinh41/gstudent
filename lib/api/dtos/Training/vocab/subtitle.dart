class Subtitle {
  Subtitle({
    this.sub,
    this.startTime,
    this.endTime,
  });
  String sub;
  int startTime;
  int endTime;

  factory Subtitle.fromString(String strStart, String startEnd, String text) {
    return Subtitle(
        sub: text,
        startTime: parseTime(strStart),
        endTime: parseTime(startEnd));
  }
}

int parseTime(String str) {
  try {
    RegExp reg = RegExp("(([0-9]{2}):([0-5][0-9]):([0-5][0-9]),([0-5]{3}))");

    var match = reg.firstMatch(str);
    if (match == null) {
      return 0;
    }
    var hour = int.tryParse(match.group(2));
    var min = int.tryParse(match.group(3));
    var sec = int.tryParse(match.group(4));
    // var misec = match.group(5);

    return hour * 60 * 60 + min * 60 + sec;
  } catch (e) {
    return 0;
  }
}
