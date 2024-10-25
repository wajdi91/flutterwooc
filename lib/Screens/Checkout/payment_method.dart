import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isChecked = false;

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  int selectedIndex = 0;

  List<String> methods = [
    'images/paypal.png',
    'images/bkash.png',
    'images/ssl.png',
    'images/stripe.png',
    'images/paytm.png',
    'images/addpayment.png',
  ];
  // ignore: prefer_typing_uninitialized_variables
  var dialogjContext;
  List<Color> colors = [
    const Color(0xFFE4F7FF),
    const Color(0xFFFFE8EE),
    const Color(0xFFEAEFF7),
    const Color(0xFFF0EFFF),
    const Color(0xFFE6F9FE),
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ButtonGlobal(
          buttontext: 'Add Card',
          buttonDecoration: kButtonDecoration.copyWith(
            color: kMainColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: (() => showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setstate) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.60,
                      expand: false,
                      maxChildSize: 1.0,
                      minChildSize: 0.60,
                      builder: (BuildContext context, ScrollController controller) {
                        return SingleChildScrollView(
                          controller: controller,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Add New Card',
                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                                    ),
                                    const Spacer(),
                                    const Icon(FeatherIcons.x).onTap(
                                      () => finish(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                CreditCardWidget(
                                  textStyle: kTextStyle.copyWith(fontSize: 10.0, color: Colors.white),
                                  cardNumber: cardNumber,
                                  expiryDate: expiryDate,
                                  cardHolderName: cardHolderName,
                                  cvvCode: cvvCode,
                                  showBackView: isCvvFocused,
                                  obscureCardNumber: true,
                                  obscureCardCvv: true,
                                  isHolderNameVisible: true,
                                  cardBgColor: kMainColor,
                                  isSwipeGestureEnabled: true,
                                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                                ),
                                CreditCardForm(
                                  formKey: formKey,
                                  // Required
                                  onCreditCardModelChange: onCreditCardModelChange,
                                  // Required
                                  obscureCvv: true,
                                  obscureNumber: true,
                                  cardNumber: cardNumber,
                                  cvvCode: cvvCode,
                                  isHolderNameVisible: true,
                                  isCardNumberVisible: true,
                                  isExpiryDateVisible: true,
                                  cardHolderName: cardHolderName,
                                  expiryDate: expiryDate,
                                  themeColor: Colors.blue,
                                  textColor: kTitleColor,
                                  cardHolderDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Card Holder',
                                  ),
                                  cardNumberDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Number',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                  ),
                                  expiryDateDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Expired Date',
                                    hintText: 'XX/XX',
                                  ),
                                  cvvCodeDecoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'CVV',
                                    hintText: 'XXX',
                                  ),
                                ),
                                ButtonGlobal(
                                  buttontext: 'Save',
                                  buttonDecoration: kButtonDecoration.copyWith(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onPressed: (() {
                                    finish(context);
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                },
              )),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Payment Methods',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Your payment cards',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        CreditCardWidget(
                          textStyle: kTextStyle.copyWith(fontSize: 10.0, color: Colors.white),
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          showBackView: isCvvFocused,
                          obscureCardNumber: true,
                          obscureCardCvv: true,
                          isHolderNameVisible: true,
                          cardBgColor: selectedIndex == 0 ? kMainColor : Colors.green,
                          isSwipeGestureEnabled: true,
                          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: kMainColor,
                                value: i == selectedIndex,
                                onChanged: (val) {
                                  setState(() {
                                    selectedIndex = i;
                                  });
                                }),
                            Text(
                              'Use as the payment methord',
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              CreditCardForm(
                formKey: formKey,
                // Required
                onCreditCardModelChange: onCreditCardModelChange,
                // Required
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                themeColor: Colors.blue,
                textColor: kTitleColor,
                cardNumberDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ),
              ).visible(false),
            ],
          ),
        ),
      ),
    );
  }
}
