import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Home Screen/home.dart';

class RedeemConfirmationScreen extends StatelessWidget {
  const RedeemConfirmationScreen({Key? key, required this.image, required this.mainText, required this.subText, required this.buttonText}) : super(key: key);

  final String image;
  final String mainText;
  final String subText;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image(
                    image: AssetImage(image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          mainText,
                          style: kTextStyle.copyWith(fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        subText,
                        style: kTextStyle.copyWith(
                          fontSize: 16,
                          color: kTitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: ButtonGlobalWithoutIcon(
                      buttontext: buttonText,
                      buttonDecoration: kButtonDecoration,
                      onPressed: () {
                        const Home().launch(context, isNewTask: true);
                      },
                      buttonTextColor: kMainColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
