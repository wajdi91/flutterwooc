import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/Providers/all_repo_providers.dart';
import 'package:my_bazar/models/product_model.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../constant.dart';
import '../Widgets/Product Grid/product_grid.dart';
import '../Widgets/shimmer/product_shimmer_widget.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({Key? key,required this.store}) : super(key: key);
  final Store store;

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(isRtl ? HardcodedTextArabic.storeDetailsText : HardcodedTextEng.storeDetailsText,style: const TextStyle(color: kTitleColor),),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final products = ref.watch(getProductOfSingleSeller(widget.store.id!));
          return SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.only(right: 40.0),
                  horizontalTitleGap: 10,
                  visualDensity: const VisualDensity(vertical: 4),
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: kMainColor.withOpacity(0.1),
                    child: const Icon(Icons.store,color: kMainColor,size: 30,),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.store.shopName ?? '',
                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      // const Spacer(),
                      // const Icon(Icons.star, color: ratingColor, size: 18.0),
                      // Text(
                      //   '(50)',
                      //   style: kTextStyle.copyWith(color: kGreyTextColor),
                      // ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.store.address?.street1 ?? ''},${widget.store.address?.street2 ?? ''},${widget.store.address?.city ?? ''},${widget.store.address?.country ?? ''}-${widget.store.address?.zip ?? ''}',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
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
                const SizedBox(
                  height: 10.0,
                ),
            Text(isRtl ? HardcodedTextArabic.allProductsText : HardcodedTextEng.allProductsText,style: const TextStyle(color: kTitleColor,fontSize: 20.0,fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 10.0,
                ),
                products.when(data: (snapShot) {
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
          );
        },),
      ),
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
