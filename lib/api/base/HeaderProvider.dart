import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class HeaderProvider {
  final String keyTokenUser = "token_user";

  Future<String> getAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(keyTokenUser);
    return value;
  }

  Future<bool> saveAuthorization(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyTokenUser, token);
    if (prefs.getString(keyTokenUser).isEmpty) {
      return false;
    }
    return true;
  }
}