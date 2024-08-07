import 'package:capture/spreedsheets/user_sheets_api.dart';
import 'package:flutter/material.dart';
import '../../captures/lib/mainUI_Widget.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetsApi.init();
  runApp(const MainUIWidget());
}

