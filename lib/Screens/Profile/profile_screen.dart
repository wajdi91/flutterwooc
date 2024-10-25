import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_bazar/Screens/Orders/my_order.dart';
import 'package:my_bazar/Screens/Profile/edit_profile.dart';
import 'package:my_bazar/Screens/Splash%20Screen/splash_screen.dart';
import 'package:my_bazar/constant.dart';
import 'package:my_bazar/language_screen_starting.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../Coupon/coupon.dart';
import '../Privacy/about.dart';
import '../Privacy/policy.dart';
import '../Widgets/shimmer/profile_shimmer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  APIService? apiService;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getCustomerData(String name, String url) async {
    SharedPreferences preferences = await _prefs;
    preferences.setString('name', name);
    preferences.setString('url', url);
  }

  @override
  initState() {
    apiService = APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        final customerDetails = ref.watch(getCustomerDetails);
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: kMainColor,
                elevation: 0.0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  isRtl ? HardcodedTextArabic.myProfile : HardcodedTextEng.myProfile,
                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              body: customerDetails.when(data: (snapShot) {
                String name = snapShot.firstName.toString() + snapShot.lastName.toString();
                getCustomerData(name, snapShot.avatarUrl.toString());
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ),
                        ),
                        width: context.width(),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      snapShot.avatarUrl.toString(),
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${snapShot.firstName.toString()} ' '${snapShot.lastName.toString()}',
                              style: kTextStyle.copyWith(color: Colors.white, fontSize: 18.0),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              snapShot.email.toString(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRtl ? HardcodedTextArabic.generalSettings : HardcodedTextEng.generalSettings,
                              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            ListTile(
                              onTap: (() => EditProfile(retrieveCustomer: snapShot).launch(context)),
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  FeatherIcons.edit,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                isRtl ? HardcodedTextArabic.myProfileScreenName : HardcodedTextEng.myProfileScreenName,
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                            ListTile(
                              onTap: (() => const Coupon().launch(context)),
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  MdiIcons.sale,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                isRtl ? HardcodedTextArabic.coupon : HardcodedTextEng.coupon,
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              onTap: () {
                                const MyOrders().launch(context);
                              },
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                isRtl ? HardcodedTextArabic.myOrderScreenName : HardcodedTextEng.myOrderScreenName,
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              onTap: () => const LanguageScreenTwo().launch(context),
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  Icons.language,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                isRtl ? HardcodedTextArabic.language : HardcodedTextEng.language,
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                            ListTile(
                              onTap: (() => const Policy().launch(context)),
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  Icons.settings_outlined,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                'Privacy & Policy',
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                            ListTile(
                              onTap: (() => const About().launch(context)),
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  FeatherIcons.helpCircle,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                'About Us',
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                            ListTile(
                              onTap: () async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.remove('customerId');
                                if (!mounted) return;
                                const SplashScreen().launch(context, isNewTask: true);
                              },
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10.0,
                              leading: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF6ED),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(
                                  Icons.logout,
                                  color: kMainColor,
                                ),
                              ),
                              title: Text(
                                isRtl ? HardcodedTextArabic.signOut : HardcodedTextEng.signOut,
                                style: kTextStyle,
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: kGreyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, error: (e, stack) {
                return Text(e.toString());
              }, loading: () {
                return const ProfileShimmerWidget();
              })),
        );
      },
    );
  }
}
