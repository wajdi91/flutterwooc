import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/Screens/Home%20Screen/product_details.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/add_to_cart_model.dart';
import '../../../models/product_model.dart';
import '../../../models/singleProductVariationsModel.dart';

class SpecialOffer extends StatefulWidget {
  const SpecialOffer({
    Key? key,
    required this.discountPercentage,
    required this.isSingleView,
    required this.categoryId,
    required this.productModel,
    this.singleProductVariations,
  }) : super(key: key);
  final SingleProductVariations? singleProductVariations;
  final String discountPercentage;
  final bool isSingleView;
  final int categoryId;
  final ProductModel productModel;

  @override
  State<SpecialOffer> createState() => _SpecialOfferState();
}

class _SpecialOfferState extends State<SpecialOffer> {
  bool isFavorite = false;
  bool isCart = false;
  double initialRating = 0;
  late double rating;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProductDetails(
          productModel: widget.productModel,
          categoryId: widget.categoryId,
        ).launch(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const [
            BoxShadow(
              color: kDarkWhite,
              spreadRadius: 5,
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                widget.isSingleView
                    ? Container(
                      height: 100,
                      width: context.width(),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.productModel.images?[0].src.toString() ?? '',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    : Container(
                      height: 100,
                      width: context.width(),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.productModel.images?[0].src.toString() ?? '',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                widget.discountPercentage.toInt() != 202
                    ? Container(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 3, right: 6.0, top: 3.0),
                        decoration: const BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            topRight: Radius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          '${widget.discountPercentage.toDouble().round().abs()}%',
                          style: kTextStyle.copyWith(color: Colors.white),
                        ),
                      )
                    : Container()
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                    child: Text(
                      widget.productModel.name.toString(),
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.productModel.store?.shopName ?? '',
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  const SizedBox(height: 4.0),
                  widget.singleProductVariations != null
                      ? Row(
                          children: [
                            Text(
                              widget.singleProductVariations?.salePrice.toInt() == 0 ? '\$${widget.singleProductVariations?.regularPrice ?? ''}' : '\$${widget.singleProductVariations?.salePrice ?? ''}',
                              style: kTextStyle.copyWith(color: kMainColor, fontSize: 14.0),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.singleProductVariations?.regularPrice.toInt() == 0
                                  ? '\$${widget.singleProductVariations?.regularPrice ?? ''}'
                                  : '\$${widget.singleProductVariations?.salePrice ?? ''}',
                              style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                            ).visible(widget.singleProductVariations?.salePrice.toInt() != 0)
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              widget.productModel.salePrice.toInt() <= 0 ? '\$${widget.productModel.regularPrice}' : '\$${widget.productModel.salePrice}',
                              style: kTextStyle.copyWith(color: kMainColor, fontSize: 14.0),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.productModel.regularPrice.toInt() <= 0 ? '\$${widget.productModel.salePrice}' : '\$${widget.productModel.regularPrice}',
                              style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                            ).visible(widget.singleProductVariations?.salePrice.toInt() != 0)
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BestSellingProduct extends StatefulWidget {
  const BestSellingProduct({
    Key? key,
    required this.discountPercentage,
    required this.isSingleView,
    required this.categoryId,
    required this.productModel,
    this.singleProductVariations,
  }) : super(key: key);
  final SingleProductVariations? singleProductVariations;
  final String discountPercentage;
  final bool isSingleView;
  final int categoryId;
  final ProductModel productModel;

  @override
  State<BestSellingProduct> createState() => _BestSellingProductState();
}

class _BestSellingProductState extends State<BestSellingProduct> {
  bool isFavorite = false;
  double initialRating = 0;
  late double rating;
  bool alreadyInCart = false;
  double variationRegularPrice = 0;
  double variationSalePrice = 0;
  int? finalProductVariationId;
  List<List<dynamic>> attributeList = [];
  List<dynamic> attributeNameList = [];
  List<dynamic> selectedAttributes = [];
  int productQuantity = 1;

  bool isCart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProductDetails(
          productModel: widget.productModel,
          categoryId: widget.categoryId,
        ).launch(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const [
            BoxShadow(
              color: kDarkWhite,
              spreadRadius: 5,
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                widget.isSingleView
                    ? Container(
                      height: 125,
                      width: context.width(),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.productModel.images?[0].src.toString() ??
                                'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    : Container(
                      height: 125,
                      width: context.width(),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.productModel.images?[0].src.toString() ??
                                'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                widget.discountPercentage.toInt() != 202
                    ? Row(
                        children: [
                          Container(
                            height: 30,
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: kMainColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              '${widget.discountPercentage.toDouble().round().abs()}\n%',
                              textAlign: TextAlign.center,
                              style: kTextStyle.copyWith(color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0, top: 5),
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: isFavorite
                                    ? const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          color: kMainColor,
                                        ),
                                      )
                                    : const Center(child: Icon(Icons.favorite_border)),
                              ),
                            ),
                          ).visible(false),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0, top: 5),
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: isFavorite
                                    ? const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          color: kMainColor,
                                        ),
                                      )
                                    : const Center(child: Icon(Icons.favorite_border)),
                              ),
                            ),
                          ),
                        ],
                      ).visible(false),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: Text(
                      widget.productModel.name.toString(),
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        widget.productModel.store?.shopName ?? '',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  widget.singleProductVariations != null
                      ? Row(
                          children: [
                            Text(
                              widget.singleProductVariations?.salePrice.toInt() == 0 ? '\$${widget.singleProductVariations?.regularPrice ?? ''}' : '\$${widget.singleProductVariations?.salePrice ?? ''}',
                              style: kTextStyle.copyWith(color: kMainColor, fontSize: 14.0),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.singleProductVariations?.regularPrice.toInt() == 0
                                  ? '\$${widget.singleProductVariations?.regularPrice ?? ''}'
                                  : '\$${widget.singleProductVariations?.salePrice ?? ''}',
                              style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                            ).visible(widget.singleProductVariations?.salePrice.toInt() != 0),
                            const Spacer(),
                            Consumer(
                              builder: (context, ref, _) {
                                final cart = ref.watch(cartNotifier);
                                if (widget.productModel.type == 'simple') {
                                  for (var element in cart.cartItems) {
                                    if (element.productId == widget.productModel.id) {
                                      alreadyInCart = true;
                                    }
                                  }
                                }
                                return GestureDetector(
                                  onTap: () {
                                    if (!alreadyInCart) {
                                      cart.addItemInfo(CartOtherInfo(
                                        variationId: finalProductVariationId ?? 0,
                                        productId: widget.productModel.id,
                                        quantity: productQuantity,
                                        type: widget.productModel.type,
                                        productName: widget.productModel.name,
                                        productImage: widget.productModel.images![0].src,
                                        productPrice: widget.productModel.type != 'simple'
                                            ? variationSalePrice.toDouble() <= 0
                                                ? variationRegularPrice.toDouble()
                                                : variationSalePrice.toDouble()
                                            : widget.productModel.salePrice.toDouble() <= 0
                                                ? widget.productModel.regularPrice.toDouble()
                                                : widget.productModel.salePrice.toDouble(),
                                        attributesName: widget.productModel.type != 'simple' ? attributeNameList : [],
                                        selectedAttributes: widget.productModel.type != 'simple' ? selectedAttributes : [],
                                      ));
                                      setState(() {
                                        alreadyInCart = true;
                                        isCart = !isCart;
                                      });
                                    } else {
                                      '';
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: isCart ? kMainColor : kGreyTextColor),
                                    child: const Icon(IconlyLight.bag, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              widget.productModel.salePrice.toInt() <= 0 ? '\$${widget.productModel.regularPrice}' : '\$${widget.productModel.salePrice}',
                              style: kTextStyle.copyWith(color: kMainColor, fontSize: 14.0),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.productModel.regularPrice.toInt() <= 0 ? '\$${widget.productModel.salePrice}' : '\$${widget.productModel.regularPrice}',
                              style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                            ).visible(widget.singleProductVariations?.salePrice.toInt() != 0),
                            const Spacer(),
                            Consumer(
                              builder: (context, ref, _) {
                                final cart = ref.watch(cartNotifier);
                                if (widget.productModel.type == 'simple') {
                                  for (var element in cart.cartItems) {
                                    if (element.productId == widget.productModel.id) {
                                      alreadyInCart = true;
                                    }
                                  }
                                }
                                return GestureDetector(
                                  // onTap: () {
                                  //   if (!alreadyInCart) {
                                  //     cart.addItemInfo(CartOtherInfo(
                                  //       variationId: finalProductVariationId ?? 0,
                                  //       productId: widget.productModel.id,
                                  //       quantity: productQuantity,
                                  //       type: widget.productModel.type,
                                  //       productName: widget.productModel.name,
                                  //       productImage: widget.productModel.images![0].src,
                                  //       productPrice: widget.productModel.type != 'simple'
                                  //           ? variationSalePrice.toDouble() <= 0
                                  //               ? variationRegularPrice.toDouble()
                                  //               : variationSalePrice.toDouble()
                                  //           : widget.productModel.salePrice.toDouble() <= 0
                                  //               ? widget.productModel.regularPrice.toDouble()
                                  //               : widget.productModel.salePrice.toDouble(),
                                  //       attributesName: widget.productModel.type != 'simple' ? attributeNameList : [],
                                  //       selectedAttributes: widget.productModel.type != 'simple' ? selectedAttributes : [],
                                  //     ));
                                  //     setState(() {
                                  //       alreadyInCart = true;
                                  //       isCart = !isCart;
                                  //     });
                                  //   } else {
                                  //     '';
                                  //   }
                                  // },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: isCart ? kMainColor : kGreyTextColor),
                                    child: const Icon(IconlyLight.bag, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PopularProduct extends StatefulWidget {
  const PopularProduct({
    Key? key,
    required this.discountPercentage,
    required this.isSingleView,
    required this.categoryId,
    required this.productModel,
    this.singleProductVariations,
  }) : super(key: key);
  final SingleProductVariations? singleProductVariations;
  final String discountPercentage;
  final bool isSingleView;
  final int categoryId;
  final ProductModel productModel;

  @override
  State<PopularProduct> createState() => _PopularProductState();
}

class _PopularProductState extends State<PopularProduct> {
  bool isFavorite = false;
  double initialRating = 0;
  late double rating;
  bool alreadyInCart = false;
  double variationRegularPrice = 0;
  double variationSalePrice = 0;
  int? finalProductVariationId;
  List<List<dynamic>> attributeList = [];
  List<dynamic> attributeNameList = [];
  List<dynamic> selectedAttributes = [];
  int productQuantity = 1;
  bool isCart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProductDetails(
          productModel: widget.productModel,
          categoryId: widget.categoryId,
        ).launch(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.8,
        height: 240,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const [
            BoxShadow(
              color: kDarkWhite,
              spreadRadius: 5,
              blurRadius: 4,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                widget.isSingleView
                    ? Container(
                      height: 125,
                      width: context.width(),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.productModel.images?[0].src.toString() ??
                                'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    : Container(
                      height: 125,
                      width: context.width() / 1,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.productModel.images?[0].src.toString() ??
                                'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                widget.discountPercentage.toInt() != 202
                    ? Row(
                        children: [
                          Container(
                            height: 30,
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: kMainColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              '${widget.discountPercentage.toDouble().round().abs()}\n%',
                              textAlign: TextAlign.center,
                              style: kTextStyle.copyWith(color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0, top: 5),
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: isFavorite
                                    ? const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          color: kMainColor,
                                        ),
                                      )
                                    : const Center(child: Icon(Icons.favorite_border)),
                              ),
                            ),
                          ).visible(false),
                        ],
                      )
                    : Container()
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                    child: Text(
                      widget.productModel.name.toString(),
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.productModel.store?.shopName ?? '',
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  widget.singleProductVariations != null
                      ? Row(
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 20,
                                child: Text(
                                  widget.singleProductVariations?.salePrice.toInt() == 0
                                      ? '\$${widget.singleProductVariations?.regularPrice ?? ''}'
                                      : '\$${widget.singleProductVariations?.salePrice ?? ''}',
                                  style: kTextStyle.copyWith(color: kMainColor, fontSize: 14.0),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Flexible(
                              child: Text(
                                widget.singleProductVariations?.regularPrice.toInt() == 0
                                    ? '\$${widget.singleProductVariations?.regularPrice ?? ''}'
                                    : '\$${widget.singleProductVariations?.salePrice ?? ''}',
                                style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ).visible(widget.singleProductVariations?.salePrice.toInt() != 0),
                            ),
                            const Spacer(),
                            Consumer(
                              builder: (context, ref, _) {
                                final cart = ref.watch(cartNotifier);
                                if (widget.productModel.type == 'simple') {
                                  for (var element in cart.cartItems) {
                                    if (element.productId == widget.productModel.id) {
                                      alreadyInCart = true;
                                    }
                                  }
                                }
                                return GestureDetector(
                                  onTap: () {
                                    if (!alreadyInCart) {
                                      cart.addItemInfo(CartOtherInfo(
                                        variationId: finalProductVariationId ?? 0,
                                        productId: widget.productModel.id,
                                        quantity: productQuantity,
                                        type: widget.productModel.type,
                                        productName: widget.productModel.name,
                                        productImage: widget.productModel.images![0].src,
                                        productPrice: widget.productModel.type != 'simple'
                                            ? variationSalePrice.toDouble() <= 0
                                                ? variationRegularPrice.toDouble()
                                                : variationSalePrice.toDouble()
                                            : widget.productModel.salePrice.toDouble() <= 0
                                                ? widget.productModel.regularPrice.toDouble()
                                                : widget.productModel.salePrice.toDouble(),
                                        attributesName: widget.productModel.type != 'simple' ? attributeNameList : [],
                                        selectedAttributes: widget.productModel.type != 'simple' ? selectedAttributes : [],
                                      ));
                                      setState(() {
                                        alreadyInCart = true;
                                        isCart = !isCart;
                                      });
                                    } else {
                                      '';
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: isCart ? kMainColor : kGreyTextColor),
                                    child: const Icon(IconlyLight.bag, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              widget.productModel.salePrice.toInt() <= 0 ? '\$${widget.productModel.regularPrice}' : '\$${widget.productModel.salePrice}',
                              style: kTextStyle.copyWith(color: kMainColor, fontSize: 14.0),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.productModel.regularPrice.toInt() <= 0 ? '\$${widget.productModel.salePrice}' : '\$${widget.productModel.regularPrice}',
                              style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 10.0, decoration: TextDecoration.lineThrough),
                            ).visible(widget.singleProductVariations?.salePrice.toInt() != 0),
                            const Spacer(),
                            Consumer(
                              builder: (context, ref, _) {
                                final cart = ref.watch(cartNotifier);
                                if (widget.productModel.type == 'simple') {
                                  for (var element in cart.cartItems) {
                                    if (element.productId == widget.productModel.id) {
                                      alreadyInCart = true;
                                    }
                                  }
                                }
                                return GestureDetector(
                                  // onTap: () {
                                  //   if (!alreadyInCart) {
                                  //     cart.addItemInfo(CartOtherInfo(
                                  //       variationId: finalProductVariationId ?? 0,
                                  //       productId: widget.productModel.id,
                                  //       quantity: productQuantity,
                                  //       type: widget.productModel.type,
                                  //       productName: widget.productModel.name,
                                  //       productImage: widget.productModel.images![0].src,
                                  //       productPrice: widget.productModel.type != 'simple'
                                  //           ? variationSalePrice.toDouble() <= 0
                                  //               ? variationRegularPrice.toDouble()
                                  //               : variationSalePrice.toDouble()
                                  //           : widget.productModel.salePrice.toDouble() <= 0
                                  //               ? widget.productModel.regularPrice.toDouble()
                                  //               : widget.productModel.salePrice.toDouble(),
                                  //       attributesName: widget.productModel.type != 'simple' ? attributeNameList : [],
                                  //       selectedAttributes: widget.productModel.type != 'simple' ? selectedAttributes : [],
                                  //     ));
                                  //     setState(() {
                                  //       alreadyInCart = true;
                                  //       isCart = !isCart;
                                  //     });
                                  //   } else {
                                  //     '';
                                  //   }
                                  // },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: isCart ? kMainColor : kGreyTextColor),
                                    child: const Icon(IconlyLight.bag, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
