// import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Authentication/phone_verification.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Forgot Password',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50.0,
            ),
            SizedBox(
              height: 60.0,
              child: AppTextField(
                textFieldType: TextFieldType.PHONE,
                controller: TextEditingController(),
                enabled: true,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: kMainColor),
                  ),
                  labelText: 'Phone Number',
                  hintText: '1767 432556',
                  labelStyle: kTextStyle,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE8E7E5),
                    ),
                  ),
                  // prefixIcon: CountryCodePicker(
                  //   padding: EdgeInsets.zero,
                  //   onChanged: print,
                  //   initialSelection: 'BD',
                  //   showFlag: true,
                  //   showDropDownButton: true,
                  //   alignLeft: false,
                  // ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ButtonGlobal(
              buttontext: 'Reset Password',
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: () {
                const PhoneVerification().launch(context);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
