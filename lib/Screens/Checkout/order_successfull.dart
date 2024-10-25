import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../Orders/my_order.dart';

class OrderSuccessful extends StatefulWidget {
  const OrderSuccessful({Key? key}) : super(key: key);

  @override
  _OrderSuccessfulState createState() => _OrderSuccessfulState();
}

class _OrderSuccessfulState extends State<OrderSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/check.png'),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              isRtl ? HardcodedTextArabic.orderSuccess : HardcodedTextEng.orderSuccess,
              style: kTextStyle,
            ),
            const SizedBox(
              height: 50.0,
            ),
            ButtonGlobal(
              buttontext: isRtl ? HardcodedTextArabic.orderView : HardcodedTextEng.orderView,
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: () {
                const MyOrders().launch(context);
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              isRtl ? HardcodedTextArabic.backToHomeButton : HardcodedTextEng.backToHomeButton,
              style: kTextStyle.copyWith(color: kGreyTextColor),
            ).onTap(() => const Home().launch(context)),
          ],
        ),
      ),
    );
  }
}
