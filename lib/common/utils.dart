String convertMilisec(int sec) {
  Duration duration = Duration(milliseconds: sec);
  return (duration.inMilliseconds / 1000) > 60 ? (duration.inMilliseconds / 1000).toStringAsFixed(2).replaceFirst('.', ',').padLeft(4, '0') +' phút' :  (duration.inMilliseconds / 1000).toStringAsFixed(2).replaceFirst('.', ',').padLeft(4, '0') + ' s'   ;
}

bool isEmail(String em) {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

