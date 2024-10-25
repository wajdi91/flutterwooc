import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_bazar/Screens/Home%20Screen/best_deals.dart';
import 'package:my_bazar/Screens/Home%20Screen/category_list.dart';
import 'package:my_bazar/Screens/Home%20Screen/category_product.dart';
import 'package:my_bazar/Screens/Home%20Screen/popular_products.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../constant.dart';
import '../../models/category_model.dart';
import '../Notification/notification.dart';
import '../Search/search_product_screen.dart';
import '../Widgets/Product Grid/product_grid.dart';
import '../Widgets/filter.dart';
import '../Widgets/shimmer/banner_shimmer_widget.dart';
import '../Widgets/shimmer/product_shimmer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> banner = ['images/banner1.png', 'images/banner1.png', 'images/banner1.png'];

  List<String> newArrivals = ['images/new1.png', 'images/new2.png', 'images/new3.png'];

  List<Color> productColors = [Colors.red, Colors.blue, Colors.black, Colors.pinkAccent, Colors.purpleAccent, Colors.green, Colors.black26, Colors.purple];

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  int selectedColorIndex = 0;
  int selectedSizeIndex = 1;
  double money = 01.00;
  int rate = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final bestSellingProducts = ref.watch(getProductOfSingleCategory(bestSellingProduct));
        final specialOffers = ref.watch(getProductOfSingleCategory(flashSale));
        final allCategory = ref.watch(getAllCategories);
        final allBanner = ref.watch(getBanner);
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kBorderColorTextField.withOpacity(0.3),
                  ),
                  child: const Icon(IconlyBold.category),
                ),
              ),
              title: Image.asset('images/logo.png'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: kBorderColorTextField),
                    ),
                    child: const Icon(IconlyLight.notification),
                  ).onTap(
                    () => const Notifications().launch(context),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(color: kBorderColorTextField.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                            child: AppTextField(
                              onTap: () {
                                const SearchProductScreen().launch(context);
                              },
                              readOnly: true,
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: kTitleColor,
                                ),
                                border: InputBorder.none,
                                fillColor: kBorderColorTextField,
                                hintText: isRtl ? HardcodedTextArabic.searchProduct : HardcodedTextEng.searchProduct,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            shape: BoxShape.rectangle,
                            color: kMainColor,
                          ),
                          child: const Icon(MdiIcons.tuneVariant, color: Colors.white),
                        ).onTap(
                          () => showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setstate) {
                                  return DraggableScrollableSheet(
                                    initialChildSize: 0.75,
                                    expand: false,
                                    maxChildSize: 1.0,
                                    minChildSize: 0.60,
                                    builder: (BuildContext context, ScrollController controller) {
                                      return SingleChildScrollView(
                                        controller: controller,
                                        child: const Filter(),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  //Banner Slider
                  allBanner.when(
                    data: (snapShot) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 140,
                            width: context.width(),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                PageView.builder(
                                  itemCount: snapShot.length,
                                  controller: pageController,
                                  onPageChanged: (int index) => setState(() => currentIndexPage = index),
                                  itemBuilder: (_, index) {
                                    return Container(
                                      height: 120,
                                      width: 320,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              snapShot[index].guid!.rendered.toString(),
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    );
                                  },
                                ),
                                DotIndicator(
                                  currentDotSize: 12,
                                  dotSize: 6,
                                  pageController: pageController,
                                  pages: banner,
                                  indicatorColor: Colors.white,
                                  unselectedIndicatorColor: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    error: (e, stack) {
                      return Text(e.toString());
                    },
                    loading: () {
                      return const BannerShimmerWidget();
                    },
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),
                  //Categories Section
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.categories : HardcodedTextEng.categories,
                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            const CategoryList().launch(context);
                          },
                          child: Text(
                            isRtl ? HardcodedTextArabic.showAllButton : HardcodedTextEng.showAllButton,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  allCategory.when(
                    data: (snapShot) {
                      return categoryList(snapShot);
                    },
                    error: (e, stack) {
                      return Text(e.toString());
                    },
                    loading: () {
                      return HorizontalList(
                        padding: EdgeInsets.zero,
                        spacing: 10.0,
                        itemCount: 5,
                        itemBuilder: (_, i) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 5.0, right: 10.0, top: 5.0, bottom: 5.0),
                                  height: 60.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 12.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(
                                      30.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //Flash Sale Section
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.section1 : HardcodedTextEng.section1,
                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        SlideCountdownSeparated(
                          duration: const Duration(hours: 2),
                          decoration: BoxDecoration(color: kTitleColor, borderRadius: BorderRadius.circular(4.0)),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            const BestSelling().launch(context);
                          },
                          child: Text(
                            isRtl ? HardcodedTextArabic.showAllButton : HardcodedTextEng.showAllButton,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  specialOffers.when(
                    data: (snapShot) {
                      return HorizontalList(
                        padding: const EdgeInsets.only(left: 15.0),
                        spacing: 10,
                        itemCount: snapShot.length,
                        itemBuilder: (BuildContext context, int i) {
                          final productVariation = ref.watch(getSingleProductVariation(snapShot[i].id!.toInt()));
                          return productVariation.when(data: (snapData) {
                            if (snapShot[i].type != 'simple' && snapData.isNotEmpty) {
                              int discount = discountGenerator(snapData[0].regularPrice.toString(), snapData[0].salePrice.toString());
                              return SpecialOffer(
                                singleProductVariations: snapData[0],
                                productModel: snapShot[i],
                                discountPercentage: discount.toString(),
                                categoryId: flashSale,
                                isSingleView: false,
                              );
                            } else {
                              int discount = discountGenerator(snapShot[0].regularPrice.toString(), snapShot[0].salePrice.toString());
                              return SpecialOffer(
                                productModel: snapShot[i],
                                discountPercentage: discount.toString(),
                                categoryId: flashSale,
                                isSingleView: false,
                              );
                            }
                          }, error: (e, stack) {
                            return Text(e.toString());
                          }, loading: () {
                            return Container();
                          });
                        },
                      );
                    },
                    error: (e, stack) {
                      return Text(e.toString());
                    },
                    loading: () {
                      return const Center(child: ProductShimmerWidget());
                    },
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),
                  //Best Deals Section
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.section2 : HardcodedTextEng.section2,
                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            const BestSelling().launch(context);
                          },
                          child: Text(
                            isRtl ? HardcodedTextArabic.showAllButton : HardcodedTextEng.showAllButton,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  bestSellingProducts.when(data: (snapShot) {
                    return HorizontalList(
                      padding: const EdgeInsets.only(left: 15.0),
                      spacing: 10,
                      itemCount: snapShot.length,
                      itemBuilder: (BuildContext context, int i) {
                        final productVariation = ref.watch(getSingleProductVariation(snapShot[i].id!.toInt()));
                        return productVariation.when(data: (snapData) {
                          if (snapShot[i].type != 'simple' && snapData.isNotEmpty) {
                            int discount = discountGenerator(snapData[0].regularPrice.toString(), snapData[0].salePrice.toString());
                            return BestSellingProduct(
                              singleProductVariations: snapData[0],
                              productModel: snapShot[i],
                              discountPercentage: discount.toString(),
                              categoryId: bestSellingProduct,
                              isSingleView: false,
                            );
                          } else {
                            int discount = discountGenerator(snapShot[0].regularPrice.toString(), snapShot[0].salePrice.toString());
                            return BestSellingProduct(
                              productModel: snapShot[i],
                              discountPercentage: discount.toString(),
                              categoryId: bestSellingProduct,
                              isSingleView: false,
                            );
                          }
                        }, error: (e, stack) {
                          return Text(e.toString());
                        }, loading: () {
                          return Container();
                        });
                      },
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Center(child: ProductShimmerWidget());
                  }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //New Arrivals Section
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'New Arrivals',
                  //         style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                  //       ),
                  //       const Spacer(),
                  //       GestureDetector(
                  //         onTap: () {
                  //           const BestSelling().launch(context);
                  //         },
                  //         child: Text(
                  //           'In November',
                  //           style: kTextStyle.copyWith(color: kMainColor),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Container(
                  //             height: 75,
                  //             width: 55,
                  //             padding: const EdgeInsets.only(right: 2.0),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.pink),
                  //             child: Container(
                  //               height: 75,
                  //               width: 65,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.pink,
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 image: const DecorationImage(
                  //                   image: AssetImage('images/new1.png'),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             decoration: const BoxDecoration(
                  //               borderRadius: BorderRadius.only(
                  //                 topRight: Radius.circular(10.0),
                  //                 topLeft: Radius.circular(10.0),
                  //               ),
                  //               color: kBgColor,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   'Kids Fashion',
                  //                   style: kTextStyle,
                  //                 ),
                  //                 RichText(
                  //                   text: TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                         text: 'Upto ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: '50% ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kMainColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: 'Off',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  //       Expanded(
                  //           child: Row(
                  //         children: [
                  //           Container(
                  //             height: 75,
                  //             width: 55,
                  //             padding: const EdgeInsets.only(right: 2.0),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: kMainColor),
                  //             child: Container(
                  //               height: 75,
                  //               width: 65,
                  //               decoration: BoxDecoration(
                  //                 color: CupertinoColors.opaqueSeparator,
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 image: const DecorationImage(
                  //                   image: AssetImage('images/new2.png'),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             decoration: const BoxDecoration(
                  //               borderRadius: BorderRadius.only(
                  //                 topRight: Radius.circular(10.0),
                  //                 topLeft: Radius.circular(10.0),
                  //               ),
                  //               color: kBgColor,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   'Electronics',
                  //                   style: kTextStyle,
                  //                 ),
                  //                 RichText(
                  //                   text: TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                         text: 'Upto ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: '40% ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kMainColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: 'Off',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Row(
                  //         children: [
                  //           Container(
                  //             height: 75,
                  //             width: 55,
                  //             padding: const EdgeInsets.only(right: 2.0),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.blueAccent),
                  //             child: Container(
                  //               height: 75,
                  //               width: 65,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.blue.withOpacity(0.1),
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 image: const DecorationImage(
                  //                   image: AssetImage('images/new3.png'),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             decoration: const BoxDecoration(
                  //               borderRadius: BorderRadius.only(
                  //                 topRight: Radius.circular(10.0),
                  //                 topLeft: Radius.circular(10.0),
                  //               ),
                  //               color: kBgColor,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   'Mens Fashion',
                  //                   style: kTextStyle,
                  //                 ),
                  //                 RichText(
                  //                   text: TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                         text: 'Upto ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: '70% ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kMainColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: 'Off',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  //       Expanded(
                  //           child: Row(
                  //         children: [
                  //           Container(
                  //             height: 75,
                  //             width: 55,
                  //             padding: const EdgeInsets.only(right: 2.0),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.purple),
                  //             child: Container(
                  //               height: 75,
                  //               width: 65,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.blue.withOpacity(0.1),
                  //                 borderRadius: BorderRadius.circular(6.0),
                  //                 image: const DecorationImage(
                  //                   image: AssetImage('images/new3.png'),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: const EdgeInsets.all(10.0),
                  //             decoration: const BoxDecoration(
                  //               borderRadius: BorderRadius.only(
                  //                 topRight: Radius.circular(10.0),
                  //                 topLeft: Radius.circular(10.0),
                  //               ),
                  //               color: kBgColor,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   'Girls Fashion',
                  //                   style: kTextStyle,
                  //                 ),
                  //                 RichText(
                  //                   text: TextSpan(
                  //                     children: [
                  //                       TextSpan(
                  //                         text: 'Upto ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: '30% ',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kMainColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: 'Off',
                  //                         style: kTextStyle.copyWith(
                  //                           color: kGreyTextColor,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20.0,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          isRtl ? HardcodedTextArabic.section3 : HardcodedTextEng.section3,
                          style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            const PopularProducts().launch(context);
                          },
                          child: Text(
                            isRtl ? HardcodedTextArabic.showAllButton : HardcodedTextEng.showAllButton,
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bestSellingProducts.when(data: (snapShot) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: snapShot.length < 6 ? snapShot.length : 6,
                      itemBuilder: (BuildContext context, int i) {
                        final productVariation = ref.watch(getSingleProductVariation(snapShot[i].id!.toInt()));
                        return productVariation.when(data: (snapData) {
                          if (snapShot[i].type != 'simple' && snapData.isNotEmpty) {
                            int discount = discountGenerator(snapData[0].regularPrice.toString(), snapData[0].salePrice.toString());
                            return PopularProduct(
                              singleProductVariations: snapData[0],
                              productModel: snapShot[i],
                              discountPercentage: discount.toString(),
                              categoryId: bestSellingProduct,
                              isSingleView: false,
                            );
                          } else {
                            int discount = discountGenerator(snapShot[0].regularPrice.toString(), snapShot[0].salePrice.toString());
                            return PopularProduct(
                              productModel: snapShot[i],
                              discountPercentage: discount.toString(),
                              categoryId: bestSellingProduct,
                              isSingleView: false,
                            );
                          }
                        }, error: (e, stack) {
                          return Text(e.toString());
                        }, loading: () {
                          return Container();
                        });
                      },
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Center(child: ProductShimmerWidget());
                  }),
                ],
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

  Widget categoryList(List<CategoryModel> categories) {
    final List<CategoryModel> finalCatList = [];
    for (var element in categories) {
      if (element.parent == 0) {
        finalCatList.add(element);
      }
    }
    return HorizontalList(
      padding: const EdgeInsets.only(left: 15.0),
      itemCount: finalCatList.length,
      spacing: 10,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            CategoryProduct(
              categoryId: finalCatList[index].id!.toInt(),
              categoryName: finalCatList[index].name.toString(),
              categoryList: categories,
              categoryModel: finalCatList[index],
            ).launch(context);
          },
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(finalCatList[index].image?.src.toString() ??
                          'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f'),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                finalCatList[index].name.toString(),
                style: kTextStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchItems = [
    'Car',
    'Laptop',
    'Bag',
    'Watch',
    'Shoes',
    'X-box',
    'T-shirt',
    'Watch',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.clear, color: kTitleColor),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                shape: BoxShape.rectangle,
                color: kMainColor,
              ),
              child: const Icon(MdiIcons.tuneVariant, color: Colors.white),
            ).onTap(
              () => showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setstate) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.75,
                        expand: false,
                        maxChildSize: 1.0,
                        minChildSize: 0.60,
                        builder: (BuildContext context, ScrollController controller) {
                          return SingleChildScrollView(
                            controller: controller,
                            child: const Filter(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      color: kTitleColor,
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );

    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var car in searchItems) {
      if (car.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(car);
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: matchQuery.length,
      itemBuilder: (_, i) {
        var result = matchQuery[i];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var car in searchItems) {
      if (car.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(car);
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: matchQuery.length,
      itemBuilder: (_, i) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: kBorderColorTextField.withOpacity(0.2),
            ),
            child: Text(
              matchQuery[i].toString(),
            ),
          ),
        );
      },
    );
  }
}
