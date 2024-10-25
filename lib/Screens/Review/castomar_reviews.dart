import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/product_review_model.dart';

// ignore: must_be_immutable
class CustomerReviews extends StatefulWidget {
  CustomerReviews({Key? key, this.productReviewModel}) : super(key: key);

  List<ProductReviewModel>? productReviewModel = [];

  @override
  State<CustomerReviews> createState() => _CustomerReviewsState();
}

class _CustomerReviewsState extends State<CustomerReviews> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.productReviewModel!.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(image: AssetImage('images/profile_image.png'), fit: BoxFit.fitWidth),
                  ),
                ),
                title: Text(
                  widget.productReviewModel![index].reviewer ?? '',
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
                subtitle: RatingBarWidget(
                  rating: widget.productReviewModel![index].rating!.toDouble(),
                  activeColor: ratingColor,
                  inActiveColor: ratingColor,
                  size: 12.0,
                  onRatingChanged: (aRating) {},
                ),
                trailing: Text(
                  widget.productReviewModel![index].dateCreated!.timeAgo,
                  style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 14.0),
                  textAlign: TextAlign.end,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 75),
                child: Text(
                  intl.Bidi.stripHtmlIfNeeded(widget.productReviewModel![index].review ?? ''),
                  style: kTextStyle,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
