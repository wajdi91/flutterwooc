import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool isRtl = false;

const kMainColor = Color(0xFFFF8400);
const kGreyTextColor = Color(0xFF959595);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kDarkWhite = Color(0xFFF1F7F7);
const kTitleColor = Color(0xFF040404);
const kAlertColor = Color(0xFFFF8919);
const kBgColor = Color(0xFFF7F7F8);
const kRedColor = Color(0xFFFF3232);
const ratingColor = Color(0xFFF9BC01);

const String onesignalAppId = 'Enter Your Onesignal App ID Here';

final kTextStyle = GoogleFonts.manrope(
  color: kTitleColor,
);

const kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(
      color: Color(0xFFE8E7E5),
    ),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

const int bestSellingProduct = 47;
const int flashSale = 49;
const int newArrive = 80;
const String currencySign = '\$';

List<String> employees = [
  '0 - 10',
  '11 - 20',
  '21 - 30',
  '31 - 40',
  '41 - 50',
  '51 - 60',
  '61 - 70',
  '71 - 80',
  '81 - 90',
  '91 - 100',
];
List<String> designations = ['Designer', 'Manager', 'Developer', 'Officer'];

List<String> employeeType = [
  'Full Time',
  'Part Time',
  'Freelance',
  'Remote',
];

List<String> employeeName = ['Sahidul Islam', 'Ibne Riead', 'Mehedi Muhammad', 'Emily Jones'];

List<String> genderList = ['Male', 'Female'];

List<String> expensePurpose = [
  'Marketing',
  'Transportation',
  'Device',
  'Transfer',
  'Sales',
];
List<String> posStats = [
  'Daily',
  'Monthly',
  'Yearly',
];
List<String> saleStats = [
  'Weekly',
  'Monthly',
  'Yearly',
];
