import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:my_bazar/language_screen_starting.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }



  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    defaultBlurRadius = 10.0;
    defaultSpreadRadius = 0.5;

    finish(context);
    if(prefs.getInt('customerId').toString().isEmptyOrNull){
      const LanguageScreenTwo().launch(context, isNewTask: true);
    } else{
      isRtl = prefs.getBool('rtl')?? false;
      const Home().launch(context,isNewTask: true);
    }

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            const Image(
              image: AssetImage('images/round_logo.png'),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
