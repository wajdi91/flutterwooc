import 'package:flutter/material.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Splash%20Screen/on_board.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Screens/Home Screen/home.dart';
import 'constant.dart';


class LanguageScreenTwo extends StatefulWidget {
  const LanguageScreenTwo({Key? key}) : super(key: key);

  @override
  State<LanguageScreenTwo> createState() => _LanguageScreenTwoState();
}

class _LanguageScreenTwoState extends State<LanguageScreenTwo> {
  Future<void> saveData(bool data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRtl', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: context.height() / 3,
          ),
          Text(isRtl ? 'مانستور' : 'Maan Multivendor',style: const TextStyle(color: kTitleColor,fontSize: 25.0,fontWeight: FontWeight.bold),),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRtl = false;
                  });
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: const Center(
                                child: Icon(
                                  Icons.g_translate,
                                  size: 60,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text('English',style: TextStyle(color: kTitleColor),)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.check_circle, color: kMainColor)
                          .visible(!isRtl),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRtl = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: const Center(
                                child: Icon(
                                  Icons.translate_sharp,
                                  size: 60,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text('عربى',style: TextStyle(color: kTitleColor),)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.check_circle, color: kMainColor)
                          .visible(isRtl),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonGlobal(buttontext: isRtl ? 'يحفظ' : 'Save', buttonDecoration: kButtonDecoration.copyWith(color: kMainColor), onPressed: () async{
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('rtl', isRtl);
                if(prefs.getInt('customerId').toString().isEmptyOrNull){
                  const OnBoard().launch(context, isNewTask: true);
                } else{
                  const Home().launch(context,isNewTask: true);
                }
              },
                
              ))
        ]),
      ),
    );
  }
}
