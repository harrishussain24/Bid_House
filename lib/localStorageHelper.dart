import 'package:bidhouse/models/authenticationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Localstoragehelper {
  static Future<void> savingDataToStorage(AuthenticationModel authModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('id', authModel.id!);
    await prefs.setString('email', authModel.email);
    await prefs.setString('name', authModel.name);
    await prefs.setString('phoneNo', authModel.phoneNo);
    await prefs.setString('userType', authModel.userType);
    await prefs.setString('imageUrl', authModel.imageUrl!);
  }
}
