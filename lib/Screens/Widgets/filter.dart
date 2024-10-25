import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  int selectedColorIndex = 0;
  int selectedSizeIndex = 1;
  double money = 01.00;
  int rate = 1;

  List<String> rates = ['1', '2', '3', '4', '5'];
  List<Color> productColors = [Colors.red, Colors.blue, Colors.black, Colors.pinkAccent, Colors.purpleAccent, Colors.green, Colors.black26, Colors.purple];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20.0),
        Text(
          'Filter',
          style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        const Divider(
          thickness: 1.0,
          color: kBorderColorTextField,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Slider(
                activeColor: kMainColor,
                inactiveColor: const Color(0xFFFFBFCB),
                max: 50000.0,
                value: money,
                onChanged: (double newval) {
                  setState(() {
                    money = newval;
                  });
                },
              ),
              Row(
                children: [
                  Text(
                    '\$ ${money.toInt()}',
                    style: kTextStyle.copyWith(color: kMainColor),
                  ),
                  const Spacer(),
                  Text(
                    '\$${50000.0}',
                    style: kTextStyle.copyWith(color: kMainColor),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Color',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5.0),
              HorizontalList(
                padding: EdgeInsets.zero,
                spacing: 0,
                itemCount: productColors.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: selectedColorIndex == i ? productColors[i] : Colors.white),
                      ),
                      child: CircleAvatar(
                        backgroundColor: productColors[i],
                        radius: 12.0,
                      ).onTap(
                        () {
                          setState(() {
                            selectedColorIndex = i;
                          });
                        },
                        highlightColor: context.cardColor,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                'Star Rating',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10.0),
              HorizontalList(
                padding: EdgeInsets.zero,
                spacing: 10,
                itemCount: rates.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: selectedSizeIndex == i ? kMainColor : kGreyTextColor),
                        color: selectedSizeIndex == i ? kMainColor : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: selectedSizeIndex == i ? Colors.white : kGreyTextColor, size: 18.0),
                          const SizedBox(width: 6.0),
                          Text(
                            rates[i],
                            style: kTextStyle.copyWith(color: selectedSizeIndex == i ? Colors.white : kTitleColor, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ).onTap(
                      () {
                        setState(() {
                          selectedSizeIndex = i;
                        });
                      },
                      highlightColor: context.cardColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                'Category',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        // HorizontalList(
        //   padding: const EdgeInsets.only(left: 10.0),
        //   spacing: 10,
        //   itemCount: catData.length,
        //   itemBuilder: (_, i) {
        //     return CategoryCard(
        //       categoryData: catData[i],
        //     ).onTap(
        //       () {
        //         const CategoryProduct().launch(context);
        //       },
        //       highlightColor: context.cardColor,
        //     );
        //   },
        // ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            children: [
              Expanded(
                child: ButtonGlobalWithoutIcon(
                    buttontext: 'Reset',
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red),
                    ),
                    onPressed: () {},
                    buttonTextColor: Colors.red),
              ),
              Expanded(
                child: ButtonGlobalWithoutIcon(
                    buttontext: 'Apply',
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      finish(context);
                    },
                    buttonTextColor: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
