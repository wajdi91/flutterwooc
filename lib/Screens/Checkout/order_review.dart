import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Checkout/payment_method.dart';
import 'package:my_bazar/Screens/Checkout/shipping_address.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Home Screen/home.dart';

class OrderReview extends StatefulWidget {
  const OrderReview({Key? key}) : super(key: key);

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  int productQuantity = 1;

  void showSuccessPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/success.png'), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Order successfully!',
                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Your order will be delivered soon. Thank you.',
                  textAlign: TextAlign.center,
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                ),
                const SizedBox(height: 10.0),
                ButtonGlobal(
                  buttontext: 'Back to Home',
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(8.0)),
                  onPressed: (() {
                    setState(() {
                      const Home().launch(context);
                    });
                  }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Confirm Your Order',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ButtonGlobal(
          buttontext: 'Pay Now',
          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(8.0)),
          onPressed: (() {
            setState(() {
              showSuccessPopUp();
            });
          }),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Total Item (2)',
                style: kTextStyle.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
            HorizontalList(
                spacing: 10.0,
                itemCount: 2,
                itemBuilder: (_, i) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1.0,
                          blurRadius: 1.0,
                          color: kBorderColorTextField.withOpacity(0.5),
                          offset: const Offset(0, 0),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 115,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: const DecorationImage(image: AssetImage('images/pd1.png'), fit: BoxFit.cover),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Male in casual grey T-shirt', style: kTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2.0),
                            Text(
                              'Price: \$50.00',
                              style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                            ),
                            const SizedBox(height: 2.0),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Color: ',
                                    style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0),
                                  ),
                                  WidgetSpan(
                                    child: Container(
                                      width: 14.0,
                                      height: 14.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Size: ',
                                    style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0),
                                  ),
                                  TextSpan(
                                    text: 'XL',
                                    style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.remove,
                                  color: kTitleColor,
                                ).onTap(() {
                                  setState(() {
                                    productQuantity > 1 ? productQuantity-- : productQuantity == 1;
                                  });
                                }),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  productQuantity.toString(),
                                  style: kTextStyle.copyWith(color: kMainColor, fontSize: 18.0),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(
                                  Icons.add,
                                  color: kTitleColor,
                                ).onTap(() {
                                  setState(() {
                                    productQuantity++;
                                  });
                                }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Shaidul Islam',
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(MdiIcons.checkCircle, color: Colors.green, size: 18.0),
                          const Spacer(),
                          Text(
                            'Change',
                            style: kTextStyle.copyWith(color: Colors.red, fontSize: 16.0),
                          ).onTap(
                            () => const ShippingAddress().launch(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '8 Bukit Batok Street 41, Bangladesh,361025',
                        style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 16.0),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery details',
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(MdiIcons.checkCircle, color: Colors.green, size: 18.0),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Standard Delivery',
                        style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 16.0),
                        maxLines: 3,
                      ),
                      Text(
                        '26 May 2022  (Sun 26 - Wed 30)',
                        style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 16.0),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Payment Method ',
                          style: kTextStyle.copyWith(fontSize: 18.0),
                        ),
                        const WidgetSpan(
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF16DB4D),
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 0.0),
                    leading: Image.asset('images/method.png'),
                    title: Text(
                      'Paypal',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                    subtitle: Text(
                      '4561 **** **** 0287',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                      maxLines: 2,
                    ),
                    trailing: Text(
                      'Change',
                      style: kTextStyle.copyWith(color: kRedColor),
                    ),
                    onTap: () {
                      const PaymentMethods().launch(context);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Your Order',
                    style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'SubTotal: ',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        '\$99.88',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'Delivery Fee: ',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        '\$5.00',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'VAT',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        '0.00',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  Divider(
                    color: kGreyTextColor.withOpacity(0.2),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Amount: ',
                        style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '\$104.88',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
