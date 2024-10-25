import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Home%20Screen/home.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/customer.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late APIService apiService;
  CustomerModel model = CustomerModel(email: '', userName: '', password: '');
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  initState() {
    apiService = APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isRtl
              ? HardcodedTextArabic
              .registerButtonText
              : HardcodedTextEng
              .registerButtonText,
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              Form(
                key: globalKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusColor: kMainColor,
                        labelText: isRtl
                            ? HardcodedTextArabic
                            .textFieldUserNameLabelText
                            : HardcodedTextEng
                            .textFieldUserNameLabelText,
                        hintText: isRtl
                            ? HardcodedTextArabic
                            .textFieldUserNameHintText
                            : HardcodedTextEng
                            .textFieldUserNameHintText,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldUserNameValidatorText1
                              : HardcodedTextEng
                              .textFieldUserNameValidatorText1;
                        } else if (value.length < 4) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldUserNameValidatorText2
                              : HardcodedTextEng
                              .textFieldUserNameValidatorText2;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        model.userName = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:isRtl
                            ? HardcodedTextArabic
                            .textFieldEmailLabelText
                            : HardcodedTextEng
                            .textFieldEmailLabelText,
                        hintText:isRtl
                            ? HardcodedTextArabic
                            .textFieldEmailHintText
                            : HardcodedTextEng
                            .textFieldEmailHintText,
                        focusColor: kMainColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldEmailValidatorText1
                              : HardcodedTextEng
                              .textFieldEmailValidatorText1;
                        } else if (!value.contains('@')) {
                          return isRtl
                              ? HardcodedTextArabic
                              .textFieldEmailValidatorText2
                              : HardcodedTextEng
                              .textFieldEmailValidatorText2;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        model.email = value!;
                      },
                    ),
                    const SizedBox(height: 20),
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
                        hintText:
                        isRtl
                            ? HardcodedTextArabic
                            .textFieldPassHintText
                            : HardcodedTextEng
                            .textFieldPassHintText,
                        focusColor: kMainColor,
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
                        model.password = value!;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ButtonGlobal(
                buttontext: isRtl
                    ? HardcodedTextArabic.registerButtonText
                    : HardcodedTextEng.registerButtonText,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () async {
                  if (validateAndSave()) {
                    EasyLoading.show(status: isRtl ? HardcodedTextArabic.easyLoadingRegister : HardcodedTextEng.easyLoadingRegister);

                    await apiService.createCustomer(model).then((ret) {
                      // globalKey.currentState?.reset();

                      if (ret) {
                        EasyLoading.showSuccess( isRtl ? HardcodedTextArabic.easyLoadingSuccess : HardcodedTextEng.easyLoadingSuccess);
                        const Home().launch(context);
                      } else {
                        EasyLoading.showError(isRtl ? HardcodedTextArabic.easyLoadingError : HardcodedTextEng.easyLoadingError);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
