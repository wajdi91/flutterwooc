// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Profile/profile_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/retrieve_customer.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.retrieveCustomer}) : super(key: key);

  final RetrieveCustomer retrieveCustomer;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  APIService? apiService;
  String? phoneNumber;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  RetrieveCustomer updateProfile = RetrieveCustomer();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: ButtonGlobalWithoutIcon(
              buttontext: isRtl ? HardcodedTextArabic.updateProfileButton : HardcodedTextEng.updateProfileButton,
              buttonDecoration: kButtonDecoration.copyWith(
                color: kMainColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: (() {
                if (validateAndSave()) {
                  EasyLoading.show(status:isRtl ? HardcodedTextArabic.easyLoadingUpdating : HardcodedTextEng.easyLoadingUpdating,);
                  apiService!.updateProfile(updateProfile, phoneNumber.toString()).then((value) {
                    if (value) {
                      EasyLoading.showSuccess(isRtl ? HardcodedTextArabic.easyLoadingSuccess : HardcodedTextEng.easyLoadingSuccess);

                      ref.refresh(getCustomerDetails);

                      const ProfileScreen().launch(context);
                    } else {
                      EasyLoading.showError(isRtl ? HardcodedTextArabic.easyLoadingError : HardcodedTextEng.easyLoadingError);
                    }
                  });
                }
              }),
              buttonTextColor: Colors.white,
            ),
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0.0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                  isRtl ? HardcodedTextArabic.myProfileScreenName : HardcodedTextEng.myProfileScreenName,
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: globalKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'First Name', hintText: 'Enter your first here', focusColor: kMainColor),
                                initialValue: widget.retrieveCustomer.firstName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First name cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  updateProfile.firstName = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Last Name', hintText: 'Enter your last name', focusColor: kMainColor),
                                initialValue: widget.retrieveCustomer.lastName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First name cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  updateProfile.lastName = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email', hintText: 'Enter your email address', focusColor: kMainColor),
                                initialValue: widget.retrieveCustomer.email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email cannot be empty';
                                  } else if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  updateProfile.email = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Phone', hintText: 'Enter your phone number', focusColor: kMainColor),
                                initialValue: widget.retrieveCustomer.billing!.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone Number cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  phoneNumber = value.toString();
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
