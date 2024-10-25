// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../GlobalComponents/button_global.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/list_of_orders.dart';
import '../Orders/my_order.dart';

class DeliveryStatus extends StatefulWidget {
  const DeliveryStatus({Key? key, required this.order, this.orderId}) : super(key: key);
  final ListOfOrders order;

  final int? orderId;

  @override
  _DeliveryStatusState createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus> {
  int productQuantity = 1;

  APIService? apiService;
  String? reason;
  int orderStatus = 0;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
    if (widget.order.status == 'pending') {
      orderStatus = 1;
    } else if (widget.order.status == 'processing') {
      orderStatus = 2;
    } else if (widget.order.status == 'completed') {
      orderStatus = 3;
    } else if (widget.order.status == 'delivered') {
      orderStatus = 4;
    } else if (widget.order.status == 'cancelled') {
      orderStatus = 5;
    }
  }

  void showCancelPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Consumer(
            builder: (context, ref, __) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('images/cancel.png'), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Are you sure you want to cancel this order?',
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ButtonGlobalWithoutIcon(
                            buttontext: 'No',
                            buttonTextColor: kGreyTextColor,
                            buttonDecoration: kButtonDecoration.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kGreyTextColor),
                            ),
                            onPressed: (() {
                              setState(() {
                                finish(context);
                              });
                            }),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: ButtonGlobalWithoutIcon(
                            buttontext: 'Yes',
                            buttonTextColor: Colors.white,
                            buttonDecoration: kButtonDecoration.copyWith(
                              color: kMainColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            onPressed: (() {
                              setState(
                                () {
                                  EasyLoading.show(status: 'Canceling order....');
                                  apiService!.updateOrder(widget.orderId!.toInt(), reason.toString()).then(
                                    (value) {
                                      if (value) {
                                        ref.refresh(getOrders);
                                        EasyLoading.showSuccess('Successful');

                                        const MyOrders().launch(context, isNewTask: true);
                                      } else {
                                        EasyLoading.showError('Failed with Error');
                                      }
                                    },
                                  );
                                },
                              );
                            }),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            bottomNavigationBar: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 70,
                    child: ButtonGlobalWithoutIcon(
                      buttontext: 'Back to Home',
                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(8.0)),
                      onPressed: (() {
                        setState(() {
                          const Home().launch(context);
                        });
                      }),
                      buttonTextColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 70,
                    child: ButtonGlobalWithoutIcon(
                      buttontext: isRtl ? HardcodedTextArabic.cancelOrderButton : HardcodedTextEng.cancelOrderButton,
                      buttonDecoration: kButtonDecoration.copyWith(color: Colors.white, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kGreyTextColor)),
                      onPressed: (() {
                        setState(() {
                          showCancelPopUp();
                        });
                      }),
                      buttonTextColor: kGreyTextColor,
                    ),
                  ),
                ).visible(widget.order.status != 'cancelled'),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                'Delivery Status',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Order Id: ',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                            children: [
                              TextSpan(
                                text: '#${widget.order.id.toString()}',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.order.dateCreated.toString().substring(0, 10),
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      height: 70,
                      width: 350,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Icon(orderStatus >= 1 ? Icons.check_circle : Icons.radio_button_off_sharp, size: 30, color: kMainColor),
                                ),
                                Container(height: 2, width: 70, decoration: const BoxDecoration(color: kMainColor)),
                                SizedBox(
                                  child: Icon(orderStatus >= 2 ? Icons.check_circle : Icons.radio_button_off_sharp, size: 30, color: kMainColor),
                                ),
                                Container(height: 2, width: 70, decoration: const BoxDecoration(color: kMainColor)),
                                SizedBox(
                                  child: Icon(orderStatus >= 3 ? Icons.check_circle : Icons.radio_button_off_sharp, size: 30, color: kMainColor),
                                ),
                                Container(height: 2, width: 70, decoration: const BoxDecoration(color: kMainColor)),
                                orderStatus == 5
                                    ? SizedBox(
                                        child: Icon(orderStatus == 5 ? Icons.check_circle : Icons.radio_button_off_sharp, size: 30, color: kMainColor),
                                      )
                                    : SizedBox(
                                        child: Icon(orderStatus == 4 ? Icons.check_circle : Icons.radio_button_off_sharp, size: 30, color: kMainColor),
                                      )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Pending'),
                                const Text('Processing'),
                                const Text('Completed'),
                                orderStatus == 5 ? const Text('Cancelled') : const Text('Delivered'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Total Item (${widget.order.lineItems!.length})',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      itemCount: widget.order.lineItems!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 1.0,
                                    blurRadius: 4.0,
                                    color: kBorderColorTextField.withOpacity(0.5),
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Container(
                                  //   height: 90,
                                  //   width: 90,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(8.0),
                                  //     image: const DecorationImage(image: AssetImage('images/pd1.png'), fit: BoxFit.cover),
                                  //   ),
                                  // ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.order.lineItems![i].name.toString(), style: kTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        'Price: $currencySign${widget.order.lineItems![i].total}',
                                        style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                                      ),
                                      // const SizedBox(height: 2.0),
                                      // RichText(
                                      //   text: TextSpan(
                                      //     children: [
                                      //       TextSpan(
                                      //         text: 'Color: ',
                                      //         style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0),
                                      //       ),
                                      //       WidgetSpan(
                                      //         child: Container(
                                      //           width: 14.0,
                                      //           height: 14.0,
                                      //           decoration: BoxDecoration(
                                      //             borderRadius: BorderRadius.circular(30.0),
                                      //             color: Colors.redAccent,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // const SizedBox(height: 2.0),
                                      // Row(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   children: [
                                      //     RichText(
                                      //       text: TextSpan(
                                      //         children: [
                                      //           TextSpan(
                                      //             text: 'Size: ',
                                      //             style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0),
                                      //           ),
                                      //           TextSpan(
                                      //             text: 'XL',
                                      //             style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     SizedBox(width: MediaQuery.of(context).size.width / 2.5),
                                      //     RichText(
                                      //       text: TextSpan(
                                      //         children: [
                                      //           TextSpan(
                                      //             text: 'QTY:',
                                      //             style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0),
                                      //           ),
                                      //           TextSpan(
                                      //             text: '2',
                                      //             style: kTextStyle.copyWith(color: kMainColor, fontSize: 12.0),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      isRtl ? HardcodedTextArabic.orderSummary : HardcodedTextEng.orderSummary,
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.subtotal : HardcodedTextEng.subtotal,
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                        const Spacer(),
                        Text(
                          '$currencySign${widget.order.total.toString()}',
                          style: kTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.totalAmount : HardcodedTextEng.totalAmount,
                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          '$currencySign${widget.order.total}',
                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      isRtl ? HardcodedTextArabic.paymentMethod : HardcodedTextEng.paymentMethod,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      widget.order.paymentMethodTitle.toString(),
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                    Divider(
                      thickness: 1,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      isRtl ? HardcodedTextArabic.shippingAddress : HardcodedTextEng.shippingAddress,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      '${widget.order.shipping!.firstName} ' '${widget.order.shipping!.lastName}',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      '${widget.order.shipping!.address1}, '
                      '${widget.order.shipping!.city}-'
                      '${widget.order.shipping!.postcode}, '
                      '${widget.order.shipping!.state}, '
                      '${widget.order.shipping!.country}'
                      '\n${widget.order.shipping!.phone}',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                      maxLines: 2,
                    ),
                    Divider(
                      thickness: 1,
                      color: kGreyTextColor.withOpacity(0.2),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    // Text(
                    //   'Delivery Details',
                    //   style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(
                    //   height: 8.0,
                    // ),
                    // Text(
                    //   'Standard Delivery ',
                    //   style: kTextStyle.copyWith(color: kGreyTextColor),
                    // ),
                    // const SizedBox(
                    //   height: 4.0,
                    // ),
                    // Text(
                    //   '26 May 2022  (Sun 26 - Wed 30)',
                    //   style: kTextStyle.copyWith(color: kGreyTextColor),
                    //   maxLines: 1,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
