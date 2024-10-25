import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/GlobalComponents/otp_form.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Verification',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Enter The Code',
              style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Please enter the 6-digit code sent to:',
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
          Text(
            '+8801767-543344',
            style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const OtpForm(),
          const SizedBox(
            height: 20.0,
          ),
          ButtonGlobal(
            buttontext: 'Verify',
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
            onPressed: () {
              const Home().launch(context);
            },
          ),
        ],
      ),
    );
  }
}
