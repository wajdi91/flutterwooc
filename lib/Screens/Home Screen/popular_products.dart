import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../constant.dart';
import '../Widgets/Product Grid/product_grid.dart';
import '../Widgets/shimmer/product_shimmer_widget.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final bestSellingProducts = ref.watch(getProductOfSingleCategory(bestSellingProduct));
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1.0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                isRtl ? HardcodedTextArabic.section3 : HardcodedTextEng.section3,
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
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
}
