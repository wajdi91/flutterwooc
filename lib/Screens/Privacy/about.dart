import 'package:flutter/material.dart';

import '../../constant.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: Text(
          'About Us',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
