import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  String buttonText = 'Next';
  bool isLastPage = false;

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/onboard1.png',
      "title": 'Welcome to My Bazar App',
      "description": 'Lorem ipsum dolor sit amet, consectetuer adipisci elit',
    },
    {
      "icon": 'images/onboard2.png',
      "title": 'Find Your Favorite Item Here',
      "description": 'Lorem ipsum dolor sit amet, consectetuer adipisci elit',
    },
    {
      "icon": 'images/onboard3.png',
      "title": 'Best Shopping Experience',
      "description": 'Lorem ipsum dolor sit amet, consectetuer adipisci elit',
    },
  ];

  @override
  void initState() {
    OneSignal.shared.promptUserForPushNotificationPermission();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                SizedBox(
                  height: context.height() / 1.5,
                  child: PageView.builder(
                    itemCount: sliderList.length,
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) => setState(() => currentIndexPage = index),
                    itemBuilder: (_, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(sliderList[index]['icon'], width: context.width(), height: 340),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              isRtl ? HardcodedTextArabic.splashScreenTwoHeadlines[index] : HardcodedTextEng.splashScreenTwoHeadlines[index],
                              style: kTextStyle.copyWith(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // ignore: sized_box_for_whitespace
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              width: context.width(),
                              child: Text(
                                isRtl ? HardcodedTextArabic.splashScreenTwoSubTitles[index] : HardcodedTextEng.splashScreenTwoSubTitles[index],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: kTextStyle.copyWith(
                                  color: kGreyTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                DotIndicator(
                  currentDotSize: 15,
                  dotSize: 6,
                  pageController: pageController,
                  pages: sliderList,
                  indicatorColor: kMainColor,
                  unselectedIndicatorColor: Colors.grey,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          const Home().launch(context);
                        },
                        child: Text(
                          'Skip',
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          pageController.nextPage(duration: const Duration(milliseconds: 1000), curve: Curves.linearToEaseOut);
                          // setState(
                          //   () {
                          //     // currentIndexPage <2
                          //     //     ? pageController.nextPage(
                          //     //         duration:
                          //     //             const Duration(microseconds: 1000),
                          //     //         curve: Curves.bounceInOut)
                          //     //     : setState(() {
                          //     //         isLastPage = true;
                          //     //       });
                          //   },
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kMainColor,
                          ),
                          child: Center(
                            child: Text(
                              'Next',
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).visible(currentIndexPage < 2),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ButtonGlobal(
                    buttontext: 'Get Started',
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () {
                      const Home().launch(context);
                    },
                  ),
                ).visible(currentIndexPage == 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
