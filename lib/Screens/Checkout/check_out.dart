// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Checkout/shipping_address.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Config/config.dart';
import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../models/add_to_cart_model.dart';
import '../../models/order_create_model.dart' as lee;
import '../../models/retrieve_customer.dart';
import '../Home Screen/home.dart';
import '../Widgets/shimmer/checkout_shimmer_widget.dart';
import 'order_successfull.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key, this.couponPrice}) : super(key: key);
  final double? couponPrice;

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List<lee.LineItems> lineItems = <lee.LineItems>[];
  RetrieveCustomer? retrieveCustomer;
  double totalAmount = 0;
  APIService? apiService;
  int initialValue = 1;
  RetrieveCustomer retrieveCustomers = RetrieveCustomer();
  Shipping shipping = Shipping();
  String whichPaymentIsChecked = 'Cash on Delivery';
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool addressSwitch = false;
  late APIService apiServices;
  Shipping? initShipping;
  Billing? initBilling;
  bool isCod = true;
  bool isCouponApply = false;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  List<String> title = [
    'Paypal',
    'Visa Card',
    'Cash on Delivery',
  ];

  String selectedTitle = 'Paypal';

  List<String> bankIcon = [
    'images/paypal.png',
    'images/visa.png',
    'images/paytm.png',
  ];

  bool isOn = false;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController postCode = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final cart = ref.watch(cartNotifier);
        final price = ref.watch(cartNotifier);
        final customerDetails = ref.watch(getCustomerDetails);
        return customerDetails.when(data: (customer) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonGlobal(
                    buttontext: 'Place an Order',
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () async {
                      EasyLoading.show(status: 'Creating order');
                      await apiService?.createOrder(customer, cart.cartItems, 'Cash on Delivery', false, cart.coupon).then((value) async {
                        if(isCod){
                          EasyLoading.dismiss(animation: true);
                          const OrderSuccessful().launch(context);
                        } else{
                          if (value) {
                            var snap = await apiService!.getListOfOrder();
                            if (snap.isNotEmpty) {
                              MyWebView(
                                url: snap[0].paymentUrl,
                                id: snap[0].id.toString(),
                              ).launch(context);
                            }

                            EasyLoading.dismiss(animation: true);
                            cart.cartOtherInfoList.clear();
                            cart.cartItems.clear();
                            cart.coupon.clear();
                            ref.refresh(getOrders);
                          } else {
                            EasyLoading.showError('Failed with Error');
                          }
                        }
                      });
                    },
                  ).visible(customer.shipping!.address2!.isNotEmpty || customer.shipping!.firstName!.isNotEmpty || customer.shipping!.city!.isNotEmpty || customer.billing!.phone!.isNotEmpty),
                  Center(
                    child: ButtonGlobalWithoutIcon(
                        buttontext: isRtl ? HardcodedTextArabic.addShippingAddressButton : HardcodedTextEng.addShippingAddressButton,
                        buttonDecoration: kButtonDecoration.copyWith(
                          color: kMainColor,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        onPressed: () {
                          setState(
                                () {
                              ShippingAddress(
                                initShipping: customer.shipping,
                                initBilling: customer.billing,
                                ref: ref,
                              ).launch(context);
                            },
                          );
                        },
                        buttonTextColor: Colors.white),
                  ).visible(customer.shipping!.address2!.isEmpty || customer.shipping!.firstName!.isEmpty || customer.shipping!.city!.isEmpty || customer.billing!.phone!.isEmpty),

                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1.0,
              centerTitle: true,
              title: Text(
                isRtl ? HardcodedTextArabic.checkOutScreenName : HardcodedTextEng.checkOutScreenName,
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              iconTheme: const IconThemeData(color: kTitleColor),
            ),
            body: WillPopScope(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.shippingAddress : HardcodedTextEng.shippingAddress,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            border: Border.all(color: kBorderColorTextField.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: kBorderColorTextField.withOpacity(0.4),
                                spreadRadius: 0.0,
                                blurRadius: 1.0,
                                offset: const Offset(0, 0),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${customer.shipping!.firstName} ${customer.shipping!.lastName}',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                                  ),
                                  const Spacer(),
                                  Text(
                                    isRtl ? HardcodedTextArabic.changeButton : HardcodedTextEng.changeButton,
                                    style: kTextStyle.copyWith(color: Colors.red, fontSize: 16.0),
                                  ).onTap(() => ShippingAddress(
                                        initShipping: customer.shipping,
                                        initBilling: customer.billing,
                                        ref: ref,
                                      ).launch(context)),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '${customer.shipping!.city} ${customer.shipping!.state},${customer.shipping!.address1}, ${customer.shipping!.postcode}, ${customer.shipping!.country},',
                                style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 16.0),
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).visible(customer.shipping!.address2!.isNotEmpty || customer.shipping!.firstName!.isNotEmpty || customer.shipping!.city!.isNotEmpty || customer.billing!.phone!.isNotEmpty),
                    Text(
                      'Cart Items',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(height: 10),
                    HorizontalList(
                      padding: EdgeInsets.zero,
                      itemCount: cart.cartItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 1.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: context.width() / 1.4,
                              child: Row(
                                children: [
                                  Container(
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
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: context.width() / 2.5,
                                          child: Text(
                                            cart.cartOtherInfoList[index].productName.toString(),
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
                                        Text(
                                          'Quantity: ${cart.cartOtherInfoList[index].quantity.toString()}',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      'Payment Method',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: isCod ? kMainColor.withOpacity(0.5)  : kGreyTextColor.withOpacity(0.5) )
                          ),
                          child: ListTile(
                            leading: Image.asset('images/cod.png'),
                            title: Text('Cash On Delivery',style: kTextStyle.copyWith(color: kTitleColor),),
                            trailing: Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                activeColor: kMainColor,

                                value: isCod, onChanged: (val){
                              setState(() {
                                isCod = !isCod;
                              });
                            }),
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: isCod ? kGreyTextColor.withOpacity(0.5) : kMainColor.withOpacity(0.5) )
                          ),
                          child: ListTile(
                            leading: Image.asset('images/visa.png'),
                            title: Text('Online Payments',style: kTextStyle.copyWith(color: kTitleColor),),
                            trailing: Checkbox(value: !isCod,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                activeColor: kMainColor,
                                onChanged: (val){
                              setState(() {
                                isCod = !isCod;
                              });
                            }),
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.yourOrder : HardcodedTextEng.yourOrder,
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
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

                      ],
                    ),
                  ],
                ),
              ),
              onWillPop: () async {
                return true;
              },
            ),
          );
        }, error: (e, stack) {
          return Text(e.toString());
        }, loading: () {
          return const CheckOutShimmerWidget();
        });
      },
    );
  }

  bool validateAndSave() {
    FormState form = globalKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key, required this.url, required this.id}) : super(key: key);
  final String url;
  final String id;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  bool isPaf = false;
  WebViewController? _controller;

  Future<bool> _willPopCallback() async {
    bool canNavigate = await _controller!.canGoBack();
    if (canNavigate) {
      _controller!.goBack();
      return false;
    } else {
      Future.delayed(const Duration(milliseconds: 1)).then((value) => const Home().launch(context));
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(currentUrl?.indexOf('?'));
    // print(currentUrl?.substring(0, currentUrl?.indexOf('?')));
    // print(Config.orderConfirmUrl + widget.id.toString());
    return Scaffold(
      body: WillPopScope(
        onWillPop: _willPopCallback,
        child: Stack(
          children: [
            WebView(
              onPageFinished: (url) {
                int position = url.indexOf('?') - 1;
                if (url.substring(0, position) == (Config.orderConfirmUrl + widget.id)) {
                  setState(() {
                    isPaf = true;
                  });
                }
              },
              initialUrl: widget.url,
              gestureNavigationEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                _controller = webViewController;
              },
            ),
            const OrderSuccessful().visible(isPaf),
          ],
        ),
      ),
    );
  }
}
