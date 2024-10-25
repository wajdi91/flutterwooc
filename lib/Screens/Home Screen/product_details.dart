import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_bazar/GlobalComponents/button_global.dart';
import 'package:my_bazar/Screens/Checkout/cart_screen.dart';
import 'package:my_bazar/Screens/Home%20Screen/store_details.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/config.dart';
import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/add_to_cart_model.dart';
import '../../models/list_of_orders.dart';
import '../../models/product_model.dart';
import '../../models/product_review_model.dart';
import '../../models/singleProductVariationsModel.dart';
import '../Review/castomar_reviews.dart';
import '../Review/review_bottom_sheet.dart';
import '../Review/single_product_total_review.dart';
import '../Widgets/shimmer/order_page_shimmer.dart';
import '../Widgets/shimmer/variation_product_details_shimar.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.productModel, this.singleProductsVariation, required this.categoryId}) : super(key: key);
  final ProductModel productModel;
  final SingleProductVariations? singleProductsVariation;
  final int categoryId;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late APIService apiService;
  int? simpleProductDiscount;
  int? customerId;

  Future<void> checkId() async {
    final prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId') ?? 0;
  }

  @override
  void initState() {
    checkId();
    apiService = APIService();
    simpleProductDiscount = discountGenerator(widget.productModel.regularPrice!, widget.productModel.salePrice!);
    super.initState();
  }

  PageController pageController = PageController(initialPage: 1);
  bool isItPurchased = false;
  bool isFavorite = false;
  double initialRating = 0;
  late double rating;
  bool alreadyInCart = false;

  String? selectedSize;
  Color? selectedColor;

  List<dynamic> sizeList = [];
  List<List<dynamic>> attributeList = [];
  List<dynamic> attributeNameList = [];
  List<dynamic> selectedAttributes = [];
  List<dynamic> list = [];
  List<dynamic> colorList = [];
  List<Color> finalColorList = [];
  int? finalProductVariationId;
  int simpleIntInput = 0;

  int attributesNumber = 0;
  String fistAttribute = '';

  int productQuantity = 1;
  int counter = 0;
  int counter2 = 0;

  double variationRegularPrice = 0;
  double variationSalePrice = 0;

  List<String> banner = ['images/pd1.png', 'images/pd1.png', 'images/pd1.png'];

  List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  bool description = true;

  List<Color> productColors = [Colors.red, Colors.blue, Colors.black, Colors.pinkAccent, Colors.purpleAccent];

  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  int currentIndexPage = 0;

  bool isBought = false;

  @override
  Widget build(BuildContext context) {
    counter++;
    counter2++;
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final productVariation = ref.watch(getSingleProductVariation(widget.productModel.id!.toInt()));
        return SafeArea(
          child: Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              bottomNavigationBar: Card(
                elevation: 0.0,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer(builder: (_, ref, child) {
                    //Buy_Now_button
                    final buy = ref.watch(cartNotifier);
                    if (widget.productModel.type == 'simple') {
                      for (var element in buy.cartItems) {
                        if (element.productId == widget.productModel.id) {
                          alreadyInCart = true;
                        }
                      }
                    } else {
                      for (var element in buy.cartItems) {
                        if (element.variationId == finalProductVariationId) {
                          alreadyInCart = true;
                          break;
                        } else {
                          alreadyInCart = false;
                        }
                      }
                    }

                    //Add_to_Cart_button

                    final cart = ref.watch(cartNotifier);
                    if (widget.productModel.type == 'simple') {
                      for (var element in cart.cartItems) {
                        if (element.productId == widget.productModel.id) {
                          alreadyInCart = true;
                        }
                      }
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
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
                                });
                              } else {
                                const CartScreen().launch(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Container(
                                height: 55.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                  border: Border.all(color: kMainColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      alreadyInCart
                                          ? isRtl
                                              ? HardcodedTextArabic.goToCartButton
                                              : HardcodedTextEng.goToCartButton
                                          : isRtl
                                              ? HardcodedTextArabic.addToCartButton
                                              : HardcodedTextEng.addToCartButton,
                                      style: kTextStyle.copyWith(color: kMainColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (alreadyInCart == false) {
                                buy.addItemInfo(CartOtherInfo(
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
                                const CartScreen().launch(context);
                              } else {
                                const CartScreen().launch(context);
                              }
                              setState(() {
                                alreadyInCart = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Container(
                                height: 55.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kMainColor,
                                ),
                                child: Center(
                                  child: Text(
                                    isRtl ? HardcodedTextArabic.buyNowButton : HardcodedTextEng.buyNowButton,
                                    style: kTextStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              body: SingleChildScrollView(
                child: widget.productModel.type == 'simple'
                    ? Column(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 400,
                                  width: context.width(),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      PageView.builder(
                                        itemCount: widget.productModel.images!.length,
                                        controller: pageController,
                                        onPageChanged: (int index) => setState(() => currentIndexPage = index),
                                        itemBuilder: (_, index) {
                                          return Image(
                                            image: NetworkImage(widget.productModel.images![index].src!),
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0),
                                        child: DotIndicator(
                                          currentDotSize: 12,
                                          dotSize: 6,
                                          pageController: pageController,
                                          pages: widget.productModel.images!,
                                          indicatorColor: kMainColor,
                                          unselectedIndicatorColor: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0, left: 10.0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ).onTap(() => Navigator.pop(context)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                simpleProductDiscount != 202 || widget.productModel.salePrice!.isNotEmpty
                                    ? Row(
                                        children: [
                                          Text(
                                            widget.productModel.type != 'simple' ? '$currencySign${widget.productModel.salePrice}' : '$currencySign${widget.productModel.salePrice}',
                                            style: kTextStyle.copyWith(color: kMainColor, fontSize: 18.0),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '$currencySign${widget.productModel.regularPrice}',
                                            style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0, decoration: TextDecoration.lineThrough),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Colors.white, boxShadow: [
                                              BoxShadow(
                                                color: kBorderColorTextField.withOpacity(0.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5),
                                                spreadRadius: 1,
                                              )
                                            ]),
                                            child: Text(
                                              '$simpleProductDiscount% OFF',
                                              style: kTextStyle.copyWith(color: kMainColor),
                                            ),
                                          ),
                                          const SizedBox(width: 5.0),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            '$currencySign${widget.productModel.regularPrice} ',
                                            style: kTextStyle.copyWith(color: kGreyTextColor),
                                          )
                                        ],
                                      ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  widget.productModel.name.toString(),
                                  style: kTextStyle.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    RatingBarWidget(
                                      rating: widget.productModel.averageRating.toDouble(),
                                      itemCount: 5,
                                      inActiveColor: kGreyTextColor,
                                      activeColor: Colors.orangeAccent,
                                      disable: true,
                                      onRatingChanged: (aRating) {
                                        setState(() {
                                          initialRating = aRating;
                                        });
                                      },
                                    ),
                                    Text(
                                      widget.productModel.averageRating.toString(),
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                //Size
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Size',
                                      style: kTextStyle,
                                    ),
                                    HorizontalList(
                                      spacing: 0,
                                      itemCount: sizes.length,
                                      itemBuilder: (_, i) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: kBgColor),
                                              color: selectedSizeIndex == i ? kMainColor : Colors.white,
                                            ),
                                            child: Text(
                                              sizes[i],
                                              style: kTextStyle.copyWith(
                                                color: selectedSizeIndex == i ? Colors.white : kTitleColor,
                                              ),
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
                                  ],
                                ).visible(false),
                                const SizedBox(height: 10.0),
                                //Color
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Color',
                                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
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
                                      ],
                                    ).visible(false),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isRtl ? HardcodedTextArabic.quantity : HardcodedTextEng.quantity,
                                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: kBorderColorTextField),
                                              ),
                                              child: const Icon(
                                                MdiIcons.minus,
                                                color: kTitleColor,
                                              ).onTap(() {
                                                setState(() {
                                                  productQuantity > 1 ? productQuantity-- : productQuantity == 1;
                                                });
                                              }),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              productQuantity.toString(),
                                              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: kTitleColor),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: kTitleColor,
                                              ).onTap(() {
                                                setState(() {
                                                  productQuantity++;
                                                });
                                              }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1.0,
                                  color: kBorderColorTextField,
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  isRtl ? HardcodedTextArabic.storeText : HardcodedTextEng.storeText,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  contentPadding: const EdgeInsets.only(right: 40.0),
                                  horizontalTitleGap: 10,
                                  visualDensity: const VisualDensity(vertical: 4),
                                  leading: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: kMainColor.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.store,
                                      color: kMainColor,
                                      size: 30,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.productModel.store?.shopName ?? '',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.productModel.store?.address?.street1 ?? ''},${widget.productModel.store?.address?.street2 ?? ''},${widget.productModel.store?.address?.city ?? ''},${widget.productModel.store?.address?.country ?? ''}-${widget.productModel.store?.address?.zip ?? ''}',
                                        style: kTextStyle.copyWith(color: kGreyTextColor),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            isRtl ? HardcodedTextArabic.visitStoreText : HardcodedTextEng.visitStoreText,
                                            style: const TextStyle(color: kMainColor, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 4.0,
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_outlined,
                                            color: kMainColor,
                                            size: 18.0,
                                          ),
                                        ],
                                      ).onTap(() => StoreDetails(store: widget.productModel.store!).launch(context)),
                                      // Row(
                                      //   children: const [
                                      //     Icon(MdiIcons.facebook),
                                      //     SizedBox(width: 5.0),
                                      //     Icon(MdiIcons.twitter),
                                      //     SizedBox(width: 5.0),
                                      //     Icon(MdiIcons.instagram),
                                      //     SizedBox(width: 5.0),
                                      //     Icon(MdiIcons.linkedin),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  isRtl ? HardcodedTextArabic.description : HardcodedTextEng.description,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                const SizedBox(height: 5.0),
                                ReadMoreText(
                                  intl.Bidi.stripHtmlIfNeeded(widget.productModel.description.toString()),
                                  trimLines: 3,
                                  colorClickableText: kMainColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: isRtl ? HardcodedTextArabic.showMore : HardcodedTextEng.showMore,
                                  trimExpandedText: isRtl ? HardcodedTextArabic.showLess : HardcodedTextEng.showLess,
                                ),
                                const SizedBox(height: 15.0),
                                Text(
                                  isRtl ? HardcodedTextArabic.deliveryAndSer : HardcodedTextEng.deliveryAndSer,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10,
                                  leading: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(MdiIcons.truckOutline, color: kMainColor),
                                  ),
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.freeDelivery : HardcodedTextEng.freeDelivery,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                  ),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10,
                                  leading: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(MdiIcons.creditCard, color: kMainColor),
                                  ),
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.payOnDelivery : HardcodedTextEng.payOnDelivery,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                  ),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10,
                                  leading: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(MdiIcons.repeat, color: kMainColor),
                                  ),
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.returnDay : HardcodedTextEng.returnDay,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  iconColor: kGreyTextColor,
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.review : HardcodedTextEng.review,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  children: [
                                    FutureBuilder<List<ProductReviewModel>>(
                                      future: apiService.getRetrieveAllReview(widget.productModel.id!.toInt()),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.isNotEmpty) {
                                            return Column(
                                              children: [
                                                SingleProductTotalReview(productReviewModel: snapshot.data),
                                                const SizedBox(height: 20.0),
                                                CustomerReviews(productReviewModel: snapshot.data),
                                              ],
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    isRtl ? HardcodedTextArabic.noReview : HardcodedTextEng.noReview,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 21.0),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          return const ReviewShimmer();
                                        }
                                      },
                                    ).visible(customerId != 0),
                                    const SizedBox(height: 10),

                                    // Write Review Button

                                    FutureBuilder<List<ListOfOrders>>(
                                      future: apiService.getListOfOrder(),
                                      builder: (context, snapShot) {
                                        if (snapShot.hasData) {
                                          for (var element in snapShot.data!) {
                                            for (var elementLine in element.lineItems!) {
                                              if (elementLine.productId == widget.productModel.id) {
                                                isItPurchased = true;
                                              }
                                            }
                                          }
                                          if (isItPurchased) {
                                            return ButtonGlobalWithoutIcon(
                                              buttontext: isRtl ? HardcodedTextArabic.writeReview : HardcodedTextEng.writeReview,
                                              buttonDecoration: kButtonDecoration.copyWith(
                                                color: Colors.transparent,
                                                border: Border.all(color: kBorderColorTextField),
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              buttonTextColor: kGreyTextColor,
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                      padding: const EdgeInsets.only(top: 20.0),
                                                      decoration:
                                                          const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                                                      child: DraggableScrollableSheet(
                                                          initialChildSize: .6,
                                                          expand: false,
                                                          minChildSize: .4,
                                                          maxChildSize: 1,
                                                          builder: (context, controller) {
                                                            return SingleChildScrollView(controller: controller, child: GivingRatingBottomSheet(productId: widget.productModel.id!.toInt()));
                                                          }),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            return ButtonGlobalWithoutIcon(
                                              buttontext: isRtl ? HardcodedTextArabic.writeReview : HardcodedTextEng.writeReview,
                                              buttonDecoration: kButtonDecoration.copyWith(
                                                color: Colors.transparent,
                                                border: Border.all(color: kBorderColorTextField),
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              buttonTextColor: kGreyTextColor,
                                              onPressed: () {
                                                setState(() {
                                                  showModalBottomSheet(
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(30.0),
                                                        topLeft: Radius.circular(30.0),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return const ReviewErrorBottomSheet();
                                                    },
                                                  );
                                                });
                                              },
                                            );
                                          }
                                        } else {
                                          return Center(
                                            child: Container(),
                                          );
                                        }
                                      },
                                    ).visible(customerId != 0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : productVariation.when(
                        data: (snapShot) {
                          ///__________Select_Size & Color Logic________________________________________
                          if (counter <= 1) {
                            for (int i = 0; i < snapShot[0].attributes!.length; i++) {
                              List<String> demoList = [];
                              for (var element in snapShot) {
                                demoList.add(element.attributes![i].option.toString());
                              }
                              demoList = demoList.toSet().toList();
                              attributeList.add(demoList);
                            }

                            for (var element in snapShot[0].attributes!) {
                              attributeNameList.add(element.name);
                              selectedAttributes.add('null');
                            }

                            for (int i = 0; i < selectedAttributes.length; i++) {
                              selectedAttributes[i] = attributeList[i][0];
                            }
                            attributeList = attributeList.toSet().toList();
                          }
                          if (counter2 <= 1) {
                            getSingleProductVariations(
                              productID: widget.productModel.id!.toInt(),
                              selectedAttributes: selectedAttributes,
                            );
                          }

                          ///___________WishList Logic_____________________________________________
                          int discount = 0;
                          if (variationRegularPrice != 0 || variationSalePrice != 0) {
                            discount = discountGenerator(
                              variationRegularPrice.toString(),
                              variationSalePrice.toString(),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 400,
                                    width: context.width(),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        PageView.builder(
                                          itemCount: widget.productModel.images!.length,
                                          controller: pageController,
                                          onPageChanged: (int index) => setState(() => currentIndexPage = index),
                                          itemBuilder: (_, index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image(
                                                  image: NetworkImage(widget.productModel.images![index].src!),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 20.0),
                                          child: DotIndicator(
                                            currentDotSize: 12,
                                            dotSize: 6,
                                            pageController: pageController,
                                            pages: banner,
                                            indicatorColor: kMainColor,
                                            unselectedIndicatorColor: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                variationSalePrice > 0
                                    ? Row(
                                        children: [
                                          Text(
                                            widget.productModel.type != 'simple' ? '$currencySign$variationSalePrice ' : '$currencySign${widget.productModel.salePrice}',
                                            style: kTextStyle.copyWith(color: kMainColor, fontSize: 18.0),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '$currencySign$variationRegularPrice ',
                                            style: kTextStyle.copyWith(color: kGreyTextColor, fontSize: 12.0, decoration: TextDecoration.lineThrough),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Colors.white, boxShadow: [
                                              BoxShadow(
                                                color: kBorderColorTextField.withOpacity(0.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5),
                                                spreadRadius: 1,
                                              )
                                            ]),
                                            child: Text(
                                              '$discount% OFF',
                                              style: kTextStyle.copyWith(color: kMainColor),
                                            ),
                                          ),
                                          const SizedBox(width: 5.0),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            '$currencySign$variationRegularPrice',
                                            style: kTextStyle.copyWith(color: kGreyTextColor),
                                          )
                                        ],
                                      ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  widget.productModel.name.toString(),
                                  style: kTextStyle.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: [
                                    RatingBarWidget(
                                      rating: initialRating,
                                      itemCount: 5,
                                      inActiveColor: kGreyTextColor,
                                      activeColor: Colors.orangeAccent,
                                      onRatingChanged: (aRating) {
                                        setState(() {
                                          initialRating = aRating;
                                        });
                                      },
                                    ),
                                    Text(
                                      '${widget.productModel.averageRating.toString()}${widget.productModel.averageRating.toString()}',
                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15.0),
                                //Size
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: attributeList.length,
                                      itemBuilder: (context, i) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Select ${attributeNameList[i]}',
                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 10.0),
                                                HorizontalList(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  spacing: 5,
                                                  itemCount: attributeList[i].length,
                                                  itemBuilder: (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          counter2 = 0;
                                                          selectedAttributes[i] = attributeList[i][index];
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10.0),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: selectedAttributes[i] == attributeList[i][index] ? kMainColor : kGreyTextColor.withOpacity(0.2),
                                                        ),
                                                        child: Text(
                                                          attributeList[i][index],
                                                          style: kTextStyle.copyWith(
                                                            color: selectedAttributes[i] == attributeList[i][index] ? Colors.white : kTitleColor,
                                                            fontSize: 12.0,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isRtl ? HardcodedTextArabic.quantity : HardcodedTextEng.quantity,
                                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: kBorderColorTextField),
                                              ),
                                              child: const Icon(
                                                MdiIcons.minus,
                                                color: kTitleColor,
                                              ).onTap(() {
                                                setState(() {
                                                  productQuantity > 1 ? productQuantity-- : productQuantity == 1;
                                                });
                                              }),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              productQuantity.toString(),
                                              style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: kTitleColor),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: kTitleColor,
                                              ).onTap(() {
                                                setState(() {
                                                  productQuantity++;
                                                });
                                              }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                const Divider(
                                  thickness: 1.0,
                                  color: kBorderColorTextField,
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  isRtl ? HardcodedTextArabic.storeText : HardcodedTextEng.storeText,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  contentPadding: const EdgeInsets.only(right: 40.0),
                                  horizontalTitleGap: 10,
                                  visualDensity: const VisualDensity(vertical: 4),
                                  leading: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: kMainColor.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.store,
                                      color: kMainColor,
                                      size: 30,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.productModel.store?.shopName ?? '',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.productModel.store?.address?.street1 ?? ''},${widget.productModel.store?.address?.street2 ?? ''},${widget.productModel.store?.address?.city ?? ''},${widget.productModel.store?.address?.country ?? ''}-${widget.productModel.store?.address?.zip ?? ''}',
                                        style: kTextStyle.copyWith(color: kGreyTextColor),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            isRtl ? HardcodedTextArabic.visitStoreText : HardcodedTextEng.visitStoreText,
                                            style: const TextStyle(color: kMainColor, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 4.0,
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_outlined,
                                            color: kMainColor,
                                            size: 18.0,
                                          ),
                                        ],
                                      ).onTap(() => StoreDetails(store: widget.productModel.store!).launch(context)),
                                      // Row(
                                      //   children: const [
                                      //     Icon(MdiIcons.facebook),
                                      //     SizedBox(width: 5.0),
                                      //     Icon(MdiIcons.twitter),
                                      //     SizedBox(width: 5.0),
                                      //     Icon(MdiIcons.instagram),
                                      //     SizedBox(width: 5.0),
                                      //     Icon(MdiIcons.linkedin),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  isRtl ? HardcodedTextArabic.description : HardcodedTextEng.description,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                const SizedBox(height: 5.0),
                                ReadMoreText(
                                  intl.Bidi.stripHtmlIfNeeded(widget.productModel.description.toString()),
                                  trimLines: 3,
                                  colorClickableText: kMainColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: isRtl ? HardcodedTextArabic.showMore : HardcodedTextEng.showMore,
                                  trimExpandedText: isRtl ? HardcodedTextArabic.showLess : HardcodedTextEng.showLess,
                                ),
                                const SizedBox(height: 15.0),
                                Text(
                                  isRtl ? HardcodedTextArabic.deliveryAndSer : HardcodedTextEng.deliveryAndSer,
                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10,
                                  leading: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(MdiIcons.truckOutline, color: kMainColor),
                                  ),
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.freeDelivery : HardcodedTextEng.freeDelivery,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                  ),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10,
                                  leading: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(MdiIcons.creditCard, color: kMainColor),
                                  ),
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.payOnDelivery : HardcodedTextEng.payOnDelivery,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                  ),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10,
                                  leading: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(MdiIcons.repeat, color: kMainColor),
                                  ),
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.returnDay : HardcodedTextEng.returnDay,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  iconColor: kGreyTextColor,
                                  title: Text(
                                    isRtl ? HardcodedTextArabic.review : HardcodedTextEng.review,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  children: [
                                    FutureBuilder<List<ProductReviewModel>>(
                                      future: apiService.getRetrieveAllReview(widget.productModel.id!.toInt()),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.isNotEmpty) {
                                            return Column(
                                              children: [
                                                SingleProductTotalReview(productReviewModel: snapshot.data),
                                                const SizedBox(height: 20.0),
                                                CustomerReviews(productReviewModel: snapshot.data),
                                              ],
                                            );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    isRtl ? HardcodedTextArabic.noReview : HardcodedTextEng.noReview,
                                                    style: kTextStyle.copyWith(color: kTitleColor, fontSize: 21.0),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          return const ReviewShimmer();
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),

                                    // Write Review Button

                                    FutureBuilder<List<ListOfOrders>>(
                                      future: apiService.getListOfOrder(),
                                      builder: (context, snapShot) {
                                        if (snapShot.hasData) {
                                          for (var element in snapShot.data!) {
                                            for (var elementLine in element.lineItems!) {
                                              if (elementLine.productId == widget.productModel.id) {
                                                isItPurchased = true;
                                              }
                                            }
                                          }
                                          if (isItPurchased) {
                                            return ButtonGlobalWithoutIcon(
                                              buttontext: isRtl ? HardcodedTextArabic.writeAReview : HardcodedTextEng.writeAReview,
                                              buttonDecoration: kButtonDecoration.copyWith(
                                                color: Colors.transparent,
                                                border: Border.all(color: kBorderColorTextField),
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              buttonTextColor: kGreyTextColor,
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                      padding: const EdgeInsets.only(top: 20.0),
                                                      decoration:
                                                          const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                                                      child: DraggableScrollableSheet(
                                                          initialChildSize: .6,
                                                          expand: false,
                                                          minChildSize: .4,
                                                          maxChildSize: 1,
                                                          builder: (context, controller) {
                                                            return SingleChildScrollView(controller: controller, child: GivingRatingBottomSheet(productId: widget.productModel.id!.toInt()));
                                                          }),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            return ButtonGlobalWithoutIcon(
                                              buttontext: isRtl ? HardcodedTextArabic.writeReview : HardcodedTextEng.writeReview,
                                              buttonDecoration: kButtonDecoration.copyWith(
                                                color: Colors.transparent,
                                                border: Border.all(color: kBorderColorTextField),
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              buttonTextColor: kGreyTextColor,
                                              onPressed: () {
                                                setState(() {
                                                  showModalBottomSheet(
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(30.0),
                                                        topLeft: Radius.circular(30.0),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return const ReviewErrorBottomSheet();
                                                    },
                                                  );
                                                });
                                              },
                                            );
                                          }
                                        } else {
                                          return Center(
                                            child: Container(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        error: (e, stack) {
                          return Text(e.toString());
                        },
                        loading: () {
                          return const VariationProductDetailsShimmer();
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  int discountGenerator(String regularPrice, String sellingPrice) {
    double discount;

    if (regularPrice.isEmpty || sellingPrice.isEmpty) {
      return 202;
    } else {
      discount = ((double.parse(sellingPrice) * 100) / double.parse(regularPrice)) - 100;
    }

    return discount.toInt();
  }

  void getSingleProductVariations({required int productID, required List<dynamic> selectedAttributes}) async {
    EasyLoading.show(status: 'loading');
    List<SingleProductVariations> productVariation = [];

    String url = '${Config.url}products/$productID/variations?consumer_key=${Config.key}&consumer_secret=${Config.secret}&per_page=50';
    var response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in data) {
        productVariation.add(SingleProductVariations.fromJson(i));
      }

      for (var element in productVariation) {
        int numberOfTrue = 0;

        for (int j = 0; j < element.attributes!.length; j++) {
          if (element.attributes![j].option == selectedAttributes[j]) {
            numberOfTrue++;
          }
        }
        if (numberOfTrue == selectedAttributes.length) {
          setState(() {
            variationSalePrice = element.salePrice.toDouble();
            variationRegularPrice = element.regularPrice.toDouble();
            finalProductVariationId = element.id!.toInt();
          });
        }
        EasyLoading.dismiss();
      }
    }
  }
}
