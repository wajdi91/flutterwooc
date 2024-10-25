import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/retrieve_customer.dart';

class GivingRatingBottomSheet extends StatefulWidget {
  const GivingRatingBottomSheet({Key? key, required this.productId}) : super(key: key);

  final int productId;

  @override
  State<GivingRatingBottomSheet> createState() => _GivingRatingBottomSheetState();
}

class _GivingRatingBottomSheetState extends State<GivingRatingBottomSheet> {
  APIService? apiService;
  String reviewText = '';
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  double initialRating = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RetrieveCustomer>(
      future: apiService!.getCustomerDetails(),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Write a review',
                      textAlign: TextAlign.center,
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(FeatherIcons.x).onTap(
                      () => finish(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kDarkWhite,
                          spreadRadius: 7.0,
                          blurRadius: 7.0,
                          offset: Offset(0, 0),
                        )
                      ],
                      color: Colors.white),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Select Rating',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RatingBarWidget(
                          rating: initialRating,
                          activeColor: ratingColor,
                          inActiveColor: ratingColor,
                          size: 60,
                          onRatingChanged: (aRating) {
                            setState(() {
                              initialRating = aRating;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Enter Your Opinion',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: globalKey,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 10,
                          minLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            reviewText = value!;
                          },
                          decoration: InputDecoration(
                            hintText: 'Message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onChanged: (value) {
                            reviewText = value;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ButtonGlobalWithoutIcon(
                          buttontext: 'Apply',
                          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                          onPressed: () {
                            setState(() async{
                              if (validateAndSave()) {
                                EasyLoading.show(status: 'Updating....');
                                await apiService!.createReview(reviewText, initialRating.toInt(), widget.productId, snapShot.data!.username ?? '', snapShot.data!.email ?? '').then((value) {
                                  if (value) {
                                    EasyLoading.showSuccess('Successful');
                                    globalKey.currentState?.reset();
                                    finish(context);
                                  } else {
                                    EasyLoading.showError('Failed with Error');
                                    globalKey.currentState?.reset();
                                  }
                                });
                              } else {
                                EasyLoading.showError(
                                  'Please fill all inputs',
                                );
                              }
                              globalKey.currentState?.reset();
                            });
                          },
                          buttonTextColor: Colors.white),
                      const SizedBox(height: 30),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && initialRating != 0) {
      form.save();
      return true;
    }
    return false;
  }
}

class ReviewErrorBottomSheet extends StatefulWidget {
  const ReviewErrorBottomSheet({Key? key}) : super(key: key);

  @override
  State<ReviewErrorBottomSheet> createState() => _ReviewErrorBottomSheetState();
}

class _ReviewErrorBottomSheetState extends State<ReviewErrorBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(
                  'Write a review',
                  textAlign: TextAlign.center,
                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(FeatherIcons.x).onTap(
                  () => finish(context),
                ),
              ],
            ),
          ),
          Container(
            width: context.width(),
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kDarkWhite,
                    spreadRadius: 7.0,
                    blurRadius: 7.0,
                    offset: Offset(0, 0),
                  )
                ],
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kMainColor.withOpacity(0.1),
                    ),
                    child: const Icon(MdiIcons.exclamation, color: kMainColor, size: 30),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Haven’t Purchased this Product?',
                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Porta scelerisque sed lobortis in adipiscing et to rtor consectetur. Urna suscipit',
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ButtonGlobal(
                    buttontext: 'Continue Shopping',
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      setState(() {
                        finish(context);
                      });
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
