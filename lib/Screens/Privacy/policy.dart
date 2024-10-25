import 'package:flutter/material.dart';

import '../../constant.dart';

class Policy extends StatefulWidget {
  const Policy({Key? key}) : super(key: key);

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: Text(
          'Privacy Policy',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WooCommerce Privacy Policies',
              style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'A privacy policy is intended to inform users of how their personal data is collected and used. Privacy policies are essential for online stores because the stores almost always collect at least basic personal information.While privacy policies are far from a new con cept, they have become increasingly impor tant as online shopping has grown. Adding a privacy policy to your ecommerce website acts as a contract between Your policy describes the data you will collect, process, and store, and customers are allowed to review and respond to the use of their data.',
              style: kTextStyle.copyWith(color: kGreyTextColor),
            ),
            const SizedBox(height: 20.0),
            Text(
              'To Build Trust With Customers',
              style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'A privacy policy is intended to inform users of how their personal data is collected and used. Privacy policies are essential for online stores because the stores almost always collect at least basic personal information.While privacy policies are far from a new con cept, they have become increasingly impor tant as online shopping has grown. Adding a privacy policy to your ecommerce website acts as a contract between Your policy describes the data you will collect, process, and store, and customers are allowed to review and respond to the use of their data.',
              style: kTextStyle.copyWith(color: kGreyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
