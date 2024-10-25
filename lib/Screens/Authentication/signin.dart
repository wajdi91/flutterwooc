import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Authentication/sign_up.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String email = '';
  bool hidePassword = true;
  bool isChecked = false;
  String password = '';

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Sign In',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10.0, top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Text(
                  isRtl
                      ? HardcodedTextArabic
                      .welcome
                      : HardcodedTextEng
                      .welcome,
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Text(
                isRtl
                    ? HardcodedTextArabic
                    .signInToAccount
                    : HardcodedTextEng
                    .signInToAccount,
                style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 14.0),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Form(
                key: globalKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: isRtl ? HardcodedTextArabic.textFieldEmailLabelText : HardcodedTextEng.textFieldEmailLabelText,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: isRtl
                              ? HardcodedTextArabic
                              .textFieldEmailHintText
                              : HardcodedTextEng
                              .textFieldEmailHintText,),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldEmailHintText
                              : HardcodedTextEng
                              .textFieldEmailValidatorText1;
                        } else if (!value.contains('@')) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldEmailHintText
                              : HardcodedTextEng
                              .textFieldEmailValidatorText2;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                        isRtl
                            ? HardcodedTextArabic
                            .textFieldPassLabelText
                            : HardcodedTextEng
                            .textFieldPassLabelText,
                        hintText: isRtl
                            ? HardcodedTextArabic
                            .textFieldPassHintText
                            : HardcodedTextEng
                            .textFieldPassHintText,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldPassValidatorText1
                              : HardcodedTextEng
                              .textFieldPassValidatorText1;
                        } else if (value.length < 4) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldPassValidatorText2
                              : HardcodedTextEng
                              .textFieldPassValidatorText2;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value!;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: isChecked,
                      thumbColor: kGreyTextColor,
                      activeColor: kMainColor,
                      onChanged: (bool value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    isRtl
                        ? HardcodedTextArabic.rememberMe
                        : HardcodedTextEng.rememberMe,
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  // const Spacer(),
                  // Text(
                  //   isRtl
                  //       ? HardcodedTextArabic.forgetPass
                  //       : HardcodedTextEng.forgetPass,
                  //   style: kTextStyle.copyWith(color: kGreyTextColor),
                  // ).onTap(() {
                  //   const ForgotPassword().launch(context);
                  // }),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              ButtonGlobal(
                buttontext: isRtl ? HardcodedTextArabic.signInButtonText : HardcodedTextEng.signInButtonText,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  if (validateAndSave()) {
                    EasyLoading.show(status: isRtl ? HardcodedTextArabic.easyLoadingSignIn : HardcodedTextEng.easyLoadingSignIn);
                    apiService.loginCustomer(email, password).then(
                      (ret) {
                        globalKey.currentState?.reset();

                        if (ret) {
                          EasyLoading.showSuccess(isRtl ? HardcodedTextArabic.easyLoadingSuccess : HardcodedTextEng.easyLoadingSuccess);
                          const Home().launch(context, isNewTask: true);
                        } else {
                          EasyLoading.showError(isRtl ? HardcodedTextArabic.easyLoadingError : HardcodedTextEng.easyLoadingError);
                        }
                      },
                    );
                  }
                },
              ),
              const SizedBox(
                height: 50.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isRtl
                ? HardcodedTextArabic.notMember
                    : HardcodedTextEng.notMember,
                      style: kTextStyle.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                    WidgetSpan(
                      child: Text(
                        isRtl ? HardcodedTextArabic.registerButtonText : HardcodedTextEng.registerButtonText,
                        style: kTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kMainColor,
                        ),
                      ).onTap(() {
                        const SignUp().launch(context);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
