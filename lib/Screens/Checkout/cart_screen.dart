import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Checkout/check_out.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/add_to_cart_model.dart';
import '../../models/order_create_model.dart';
import '../Authentication/signin.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int cartItems = 0;
  APIService? apiService;
  int initialValueFromText = 0;
  int initialValue = 1;
  bool isCouponApply = false;
  String inputCoupon = '';
  late TextEditingController _controller;
  String finalInputCoupon = '';

  @override
  void initState() {
    apiService = APIService();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int productQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isRtl ? HardcodedTextArabic.cartScreenName : HardcodedTextEng.cartScreenName,
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final cart = ref.watch(cartNotifier);
          cartItems = cart.cartItems.length;
          if (cart.cartOtherInfoList.isEmpty) {
            return Center(
              child: Text(
                isRtl ? HardcodedTextArabic.ifNoItems : HardcodedTextEng.ifNoItems,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: context.height() / 2.2,
                    child: ListView.builder(
                      itemCount: cartItems,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 1.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 120.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: kGreyTextColor,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            cart.cartOtherInfoList[index].productImage.toString(),
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cart.cartOtherInfoList[index].productName.toString(),
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          'Price: ${cart.cartOtherInfoList[index].productPrice}\$',
                                          style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          height: 15,
                                          child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemCount: cart.cartOtherInfoList[index].attributesName!.length,
                                            itemBuilder: (context, i) {
                                              return RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${cart.cartOtherInfoList[index].attributesName![i]} : ',
                                                      style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0),
                                                      children: [
                                                        TextSpan(
                                                          text: cart.cartOtherInfoList[index].selectedAttributes![i].toString(),
                                                          style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ).visible(cart.cartOtherInfoList[index].attributesName!.isNotEmpty),
                                        const SizedBox(height: 6.0),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kGreyTextColor.withOpacity(0.2),
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                color: kTitleColor,
                                              ),
                                            ).onTap(() {
                                              setState(() {
                                                if (cart.cartOtherInfoList[index].quantity! != 1) {
                                                  isCouponApply = false;
                                                }
                                                cart.cartOtherInfoList[index].quantity! > 1 ? cart.decreaseQuantity(index) : cart.cartOtherInfoList[index].quantity = 1;
                                              });
                                            }),
                                            const SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              cart.cartOtherInfoList[index].quantity.toString(),
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 15.0,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isCouponApply = false;
                                                  cart.coupon.clear();
                                                  cart.increaseQuantity(index);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kGreyTextColor.withOpacity(0.2),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: kTitleColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      cart.removeItemInfo(cart.cartOtherInfoList[index].productName.toString());
                                      cart.coupon.clear();
                                      setState(() {
                                        isCouponApply = false;
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xFFFFEAEA),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.delete_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (_, ref, __) {
          final cart = ref.watch(cartNotifier);
          final price = ref.watch(cartNotifier);

          final double totalPrice = price.cartTotalPriceF(initialValue);
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor,
                    blurRadius: 1.0,
                    spreadRadius: 2,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    onChanged: (value) {
                      inputCoupon = value;
                    },
                    controller: _controller,
                    cursorColor: kTitleColor,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFFFEAEA),
                      focusColor: const Color(0xFFFFEAEA),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      hintText: isRtl ? HardcodedTextArabic.coupon : HardcodedTextEng.coupon,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    suffix: GestureDetector(
                      onTap: () async {
                        try {
                          if (inputCoupon == '') {
                            ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                              content: Text(
                                isRtl ? HardcodedTextArabic.enterCoupon : HardcodedTextEng.enterCoupon,
                              ),
                            ));
                          } else {
                            EasyLoading.show(status: isRtl ? HardcodedTextArabic.easyLoadingApplying : HardcodedTextEng.easyLoadingApplying);
                            setState(() {
                              finalInputCoupon = inputCoupon;
                              _controller.text = finalInputCoupon;
                            });
                            CouponLines coupon = CouponLines(code: inputCoupon);
                            price.addCoupon(coupon);
                            var promoPrice = await apiService?.retrieveCoupon(finalInputCoupon, totalPrice);
                            if (promoPrice! > 0.0) {
                              price.updatePrice(promoPrice);
                              setState(() {
                                isCouponApply = true;
                              });
                              EasyLoading.showSuccess(isRtl ? HardcodedTextArabic.easyLoadingSuccessApplied : HardcodedTextEng.easyLoadingSuccessApplied);
                            } else {
                              EasyLoading.showError(isRtl ? HardcodedTextArabic.easyLoadingError : HardcodedTextEng.easyLoadingError);
                            }
                          }
                        } catch (e) {
                          EasyLoading.showError(e.toString());
                        }
                      },
                      child: Container(
                        height: 57,
                        width: 100.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            isRtl ? HardcodedTextArabic.couponApply : HardcodedTextEng.couponApply,
                            style: kTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        isRtl ? HardcodedTextArabic.totalItems : HardcodedTextEng.totalItems,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        '${cart.cartOtherInfoList.length}',
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        isRtl ? HardcodedTextArabic.subtotal : HardcodedTextEng.subtotal,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        '\$${price.cartTotalPriceF(initialValue)}',
                        style: kTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ).visible(isCouponApply),
                  Row(
                    children: [
                      Text(
                        isRtl ? HardcodedTextArabic.discount : HardcodedTextEng.discount,
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      const Spacer(),
                      Text(
                        '\$${price.promoPrice}',
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ],
                  ).visible(isCouponApply),
                  // const SizedBox(
                  //   height: 5.0,
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Delivery Fee: ',
                  //       style: kTextStyle.copyWith(color: kGreyTextColor),
                  //     ),
                  //     const Spacer(),
                  //     Text(
                  //       '\$0.00',
                  //       style: kTextStyle,
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 5.0,
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
                        isRtl ? HardcodedTextArabic.totalAmount : HardcodedTextEng.totalAmount,
                        style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      !isCouponApply
                          ? Text(
                              '\$${price.cartTotalPriceF(initialValue)}',
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '\$${price.cartTotalPriceF(initialValue) - price.promoPrice}',
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  cart.cartItems.isNotEmpty
                      ? ButtonGlobal(
                          buttontext: isRtl ? HardcodedTextArabic.checkOutButton : HardcodedTextEng.checkOutButton,
                          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final int? customerId = prefs.getInt('customerId');
                            if (customerId == null) {
                              if (!mounted) return;
                              const SignIn().launch(context, isNewTask: true);
                            } else {
                              if (!mounted) return;
                              isCouponApply
                                  ? CheckOut(
                                      couponPrice: cart.promoPrice,
                                    ).launch(context)
                                  : const CheckOut().launch(context);
                            }
                          },
                        )
                      : ButtonGlobal(
                          buttontext: isRtl ? HardcodedTextArabic.checkOutButton : HardcodedTextEng.checkOutButton,
                          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: kBgColor,
                                padding: const EdgeInsets.all(50),
                                duration: const Duration(milliseconds: 1000),
                                content: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30.0),
                                        topLeft: Radius.circular(6.0),
                                        bottomLeft: Radius.circular(30.0),
                                        bottomRight: Radius.circular(6.0),
                                      ),
                                      color: kRedColor),
                                  child: Text(
                                      isRtl ? HardcodedTextArabic.addProductFirst : HardcodedTextEng.addProductFirst,
                                    style: kTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
