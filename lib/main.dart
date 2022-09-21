import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/data/model/users.dart';
import 'package:money_record/presentation/page/auth/home_page.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID', null).then(
    (value) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.appPrimary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.appPrimary,
          secondary: AppColor.appSecondary,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.appBackground,
            foregroundColor: Colors.white),
      ),
      home: FutureBuilder(
        future: Session.getUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.data != null && snapshot.data!.idUser != null) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
