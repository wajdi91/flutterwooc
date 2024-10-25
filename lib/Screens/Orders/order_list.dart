import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/product_data.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<String> orderStatus = ['All Order', 'Confirmed', 'Canceled', 'Shipped', 'Delivered'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'My Orders',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HorizontalList(
              spacing: 0,
              itemCount: orderStatus.length,
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      color: selectedIndex == i ? kMainColor : Colors.white,
                    ),
                    child: Text(
                      orderStatus[i],
                      style: kTextStyle.copyWith(
                        color: selectedIndex == i ? Colors.white : kTitleColor,
                      ),
                    ),
                  ).onTap(() {
                    setState(() {
                      selectedIndex = i;
                    });
                  }),
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Image.asset(productList[index].productImage),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productList[index].productTitle,
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  '#68679879',
                                  style: kTextStyle.copyWith(color: kGreyTextColor),
                                ),
                                const Spacer(),
                                Text(
                                  productList[index].productPrice,
                                  style: kTextStyle.copyWith(color: kMainColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: kBgColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  'Canceled',
                                  style: kTextStyle.copyWith(color: kRedColor),
                                ).onTap(() {}),
                              ),
                              const Spacer(),
                              Text(
                                '23 June, 2021',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
