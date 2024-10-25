import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'Screens/Splash Screen/splash_screen.dart';
import 'constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setAppId(onesignalAppId);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Add the line below to get horizontal sliding transitions for routes.
        pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
      ),
      title: 'My Bazaar',
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
