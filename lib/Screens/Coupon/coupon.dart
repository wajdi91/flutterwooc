import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../constant.dart';
import '../Widgets/shimmer/banner_shimmer_widget.dart';

class Coupon extends StatefulWidget {
  const Coupon({Key? key}) : super(key: key);

  @override
  State<Coupon> createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  Future<void> _copyToClipboard(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Coupon Copied'),
    ));
  }

  TextEditingController coupon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: kTitleColor),
          title: Text(
              isRtl ? HardcodedTextArabic.coupon : HardcodedTextEng.coupon,
            style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer(
            builder: (_, ref, __) {
              final allCoupons = ref.watch(getCoupon);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  allCoupons.when(data: (snapShot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: snapShot.length,
                        itemBuilder: (_, i) {
                          return Column(
                            children: [
                              SizedBox(
                                width: context.width(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 115,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                          color: Color(0xFF35D64A),
                                        ),
                                        child: const Center(
                                            child: Icon(
                                          MdiIcons.sale,
                                          color: Colors.white,
                                          size: 50.0,
                                        )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 115,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                          color: Color(0xFF35D64A),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Gift Card valued at\n ${snapShot[i].amount}% OFF',
                                              style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              'Expires',
                                              style: kTextStyle.copyWith(color: Colors.white),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${snapShot[i].dateExpires}',
                                                  style: kTextStyle.copyWith(color: Colors.white),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _copyToClipboard(snapShot[i].code.toString());
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 4.0, bottom: 4.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30.0),
                                                      color: Colors.white,
                                                    ),
                                                    child: Text(
                                                      'Copy',
                                                      style: kTextStyle.copyWith(
                                                        color: const Color(0xFF35D64A),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const BannerShimmerWidget();
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
