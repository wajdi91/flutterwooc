import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../Checkout/delivery_status.dart';
import '../Widgets/shimmer/order_page_shimmer.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  APIService? apiService;

  int customerId = 0;

  @override
  void initState() {
    getCustomerId();

    apiService = APIService();
    super.initState();
  }

  Future<void> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId')!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        final getAllOrders = ref.watch(getOrders);
        return DefaultTabController(
          initialIndex: 0,
          length: 4,
          child: Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                elevation: 1.0,
                iconTheme: const IconThemeData(color: kTitleColor),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  isRtl ? HardcodedTextArabic.myOrderScreenName : HardcodedTextEng.myOrderScreenName,
                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              body: getAllOrders.when(
                data: (snapShot) {
                  if (snapShot.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          labelColor: kMainColor,
                          labelStyle: kTextStyle.copyWith(color: kMainColor, fontWeight: FontWeight.bold),
                          unselectedLabelColor: kGreyTextColor,
                          unselectedLabelStyle: kTextStyle.copyWith(color: kTitleColor),
                          indicatorColor: kMainColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              text: isRtl ? HardcodedTextArabic.allOrder : HardcodedTextEng.allOrder,
                            ),
                            Tab(
                              text: isRtl ? HardcodedTextArabic.processingText : HardcodedTextEng.processingText,
                            ),
                            Tab(
                              text: isRtl ? HardcodedTextArabic.completedText : HardcodedTextEng.completedText,
                            ),
                            Tab(
                              text: isRtl ? HardcodedTextArabic.cancelledText : HardcodedTextEng.cancelledText,
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              RefreshIndicator(
                                onRefresh: () async => ref.refresh(getOrders),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                    itemCount: snapShot.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(10.0),
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          DeliveryStatus(order: snapShot[i], orderId: snapShot[i].id).launch(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                                              BoxShadow(
                                                color: kBorderColorTextField.withOpacity(0.5),
                                                blurRadius: 1.0,
                                                spreadRadius: 1.0,
                                                offset: const Offset(0, 0),
                                              )
                                            ]),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order ID: ${snapShot[i].id}',
                                                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(text: 'Items', style: kTextStyle.copyWith(color: kGreyTextColor), children: [
                                                        TextSpan(
                                                          text: '(${snapShot[i].lineItems!.length})',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        )
                                                      ]),
                                                    ),
                                                    const Spacer(),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: isRtl ? HardcodedTextArabic.totalAmount : HardcodedTextEng.totalAmount,
                                                        style: kTextStyle.copyWith(color: kGreyTextColor),
                                                        children: [
                                                          TextSpan(
                                                            text: '\$${snapShot[i].total}',
                                                            style: kTextStyle.copyWith(color: kTitleColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      snapShot[i].dateCreated.toString().substring(0, 10),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kGreyTextColor),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      snapShot[i].status.toString(),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async => ref.refresh(getOrders),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                    itemCount: snapShot.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(10.0),
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          DeliveryStatus(order: snapShot[i], orderId: snapShot[i].id).launch(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                                              BoxShadow(
                                                color: kBorderColorTextField.withOpacity(0.5),
                                                blurRadius: 1.0,
                                                spreadRadius: 1.0,
                                                offset: const Offset(0, 0),
                                              )
                                            ]),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order ID: ${snapShot[i].id}',
                                                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(text: 'Items', style: kTextStyle.copyWith(color: kGreyTextColor), children: [
                                                        TextSpan(
                                                          text: '(${snapShot[i].lineItems!.length})',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        )
                                                      ]),
                                                    ),
                                                    const Spacer(),
                                                    RichText(
                                                      text: TextSpan(
                                                        text:isRtl ? HardcodedTextArabic.totalAmount : HardcodedTextEng.totalAmount,
                                                        style: kTextStyle.copyWith(color: kGreyTextColor),
                                                        children: [
                                                          TextSpan(
                                                            text: '\$${snapShot[i].total}',
                                                            style: kTextStyle.copyWith(color: kTitleColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      snapShot[i].dateCreated.toString().substring(0, 10),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kGreyTextColor),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      snapShot[i].status.toString(),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).visible(snapShot[i].status.toString().toLowerCase() == 'processing');
                                    },
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async => ref.refresh(getOrders),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                    itemCount: snapShot.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(10.0),
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          DeliveryStatus(order: snapShot[i], orderId: snapShot[i].id).launch(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                                              BoxShadow(
                                                color: kBorderColorTextField.withOpacity(0.5),
                                                blurRadius: 1.0,
                                                spreadRadius: 1.0,
                                                offset: const Offset(0, 0),
                                              )
                                            ]),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order ID: ${snapShot[i].id}',
                                                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(text: 'Items', style: kTextStyle.copyWith(color: kGreyTextColor), children: [
                                                        TextSpan(
                                                          text: '(${snapShot[i].lineItems!.length})',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        )
                                                      ]),
                                                    ),
                                                    const Spacer(),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: isRtl ? HardcodedTextArabic.totalAmount : HardcodedTextEng.totalAmount,
                                                        style: kTextStyle.copyWith(color: kGreyTextColor),
                                                        children: [
                                                          TextSpan(
                                                            text: '\$${snapShot[i].total}',
                                                            style: kTextStyle.copyWith(color: kTitleColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      snapShot[i].dateCreated.toString().substring(0, 10),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kGreyTextColor),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      snapShot[i].status.toString(),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).visible(snapShot[i].status.toString().toLowerCase() == 'completed');
                                    },
                                  ),
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async => ref.refresh(getOrders),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                    itemCount: snapShot.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(10.0),
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          DeliveryStatus(order: snapShot[i], orderId: snapShot[i].id).launch(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0), boxShadow: [
                                              BoxShadow(
                                                color: kBorderColorTextField.withOpacity(0.5),
                                                blurRadius: 1.0,
                                                spreadRadius: 1.0,
                                                offset: const Offset(0, 0),
                                              )
                                            ]),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order ID: ${snapShot[i].id}',
                                                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(text: 'Items', style: kTextStyle.copyWith(color: kGreyTextColor), children: [
                                                        TextSpan(
                                                          text: '(${snapShot[i].lineItems!.length})',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        )
                                                      ]),
                                                    ),
                                                    const Spacer(),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: isRtl ? HardcodedTextArabic.totalAmount : HardcodedTextEng.totalAmount,
                                                        style: kTextStyle.copyWith(color: kGreyTextColor),
                                                        children: [
                                                          TextSpan(
                                                            text: '\$${snapShot[i].total}',
                                                            style: kTextStyle.copyWith(color: kTitleColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Row(
                                                  children: [
                                                    Text(
                                                      snapShot[i].dateCreated.toString().substring(0, 10),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kGreyTextColor),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      snapShot[i].status.toString(),
                                                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).visible(snapShot[i].status.toString().toLowerCase() == 'cancelled');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                   return Text(
                      isRtl ? HardcodedTextArabic.noOrder : HardcodedTextEng.noOrder,
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    );
                  }
                },
                error: (e, stack) {
                  return Text(
                    e.toString(),
                  );
                },
                loading: () {
                  return const OrderPageShimmer();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
