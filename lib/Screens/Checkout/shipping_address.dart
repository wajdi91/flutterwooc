
// ignore_for_file: unused_result
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Providers/all_repo_providers.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/retrieve_customer.dart';
import 'check_out.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({
    Key? key,
    this.initShipping,
    this.initBilling,
    this.ref,
  }) : super(key: key);
  final Shipping? initShipping;
  final Billing? initBilling;
  final WidgetRef? ref;

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  Shipping shipping = Shipping();
  late APIService apiService;
  RetrieveCustomer retrieveCustomer = RetrieveCustomer();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool addressSwitch = false;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  bool isChecked = true;
  int selectedIndex = 0;
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ButtonGlobal(
          buttontext: isRtl ? HardcodedTextArabic.saveButton : HardcodedTextEng.saveButton,
          buttonDecoration: kButtonDecoration.copyWith(
            color: kMainColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: () {
            if (validateAndSave()) {
              EasyLoading.show(status: isRtl ? HardcodedTextArabic.updateHint : HardcodedTextEng.updateHint,);
              retrieveCustomer.billing = Billing(
                firstName: shipping.firstName ?? '',
                lastName: shipping.lastName ?? '',
                company: ' ',
                address1: shipping.address1 ?? '',
                address2: shipping.address2 ?? '',
                city: shipping.city ?? '',
                postcode: shipping.postcode ?? '',
                country: shipping.country ?? '',
                phone: shipping.phone ?? '',
                email: ' ',
                state: shipping.state ?? '',
              );

              retrieveCustomer.shipping = Shipping(
                firstName: shipping.firstName ?? '',
                lastName: shipping.lastName ?? '',
                country: shipping.country ?? '',
                address1: shipping.address1 ?? '',
                address2: shipping.address2 ?? '',
                city: shipping.city ?? '',
                postcode: shipping.postcode ?? '',
                state: shipping.state ?? '',
              );
              APIService().updateShippingAddress(retrieveCustomer).then(
                (ret) {
                  if (ret) {
                    const CheckOut().launch(context, isNewTask: true);
                    widget.ref!.refresh(getCustomerDetails);
                    EasyLoading.showSuccess(isRtl ? HardcodedTextArabic.easyLoadingSuccess : HardcodedTextEng.easyLoadingSuccess,);
                  } else {
                    EasyLoading.showError(isRtl ? HardcodedTextArabic.easyLoadingError : HardcodedTextEng.easyLoadingError);
                  }
                },
              );
            }
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Shipping Address',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: WillPopScope(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10.0, top: 10.0),
            child: Form(
                key: globalKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      initialValue: widget.initShipping?.firstName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        } else if (value.length < 2) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        shipping.firstName = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: kTextStyle,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        hintText: 'Maan Theme',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE8E7E5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      initialValue: widget.initShipping?.lastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        } else if (value.length < 2) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        shipping.lastName = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: kTextStyle,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        hintText: 'Maan Theme',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE8E7E5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Country cannot be empty';
                        } else if (value.length < 2) {
                          return 'Country cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        shipping.country = value!;
                      },
                      initialValue: widget.initShipping?.country,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: kTextStyle,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        hintText: 'Bangladesh',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE8E7E5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      initialValue: widget.initShipping?.address1,
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        shipping.address1 = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Street Address',
                        labelStyle: kTextStyle,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        hintText: '8 Bukit Batok Street 41',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE8E7E5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            initialValue: widget.initShipping?.city,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                'Town / City cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              shipping.city = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Town/City',
                              labelStyle: kTextStyle,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kMainColor),
                              ),
                              hintText: 'Chandpur',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE8E7E5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            initialValue: widget.initShipping?.postcode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Postcode cannot be empty';
                              } else if (value.length < 4) {
                                return 'Postcode cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              shipping.postcode = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Post code',
                              labelStyle: kTextStyle,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kMainColor),
                              ),
                              hintText: '7596',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE8E7E5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      initialValue: widget.initShipping?.address2,
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        shipping.address2 = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: kTextStyle,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        hintText: 'shaidulislam@gmail.com',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE8E7E5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      initialValue: widget.initBilling?.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        shipping.phone = value.toString();
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: kTextStyle,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor),
                        ),
                        hintText: '017XXXXXXXX',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE8E7E5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Use as Billing address',
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                        const Spacer(),
                        Switch(
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          onChanged: (bool value) {
                            setState(() {
                              isOn = value;
                            });
                          },
                          value: isOn,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        onWillPop: () async {
          return true;
        },
      ),
    );
  }

  bool validateAndSave() {
    FormState form = globalKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
