import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({Key? key}) : super(key: key);

  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Manage Order',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Address',
              style: kTextStyle.copyWith(fontSize: 18.0),
            ),
            Text(
              'Ibne Riead - 8 Bukit Batok Street 41, Singapore ,Singapore, 361025',
              style: kTextStyle.copyWith(color: kGreyTextColor),
              maxLines: 2,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Image.asset('images/pd1.png'),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Male in casual grey T-shirt',
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
                            '\$8.99',
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
                            'Cancel',
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
            ),
          ],
        ),
      ),
    );
  }
}
