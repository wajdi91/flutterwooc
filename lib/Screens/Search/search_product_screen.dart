import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../models/singleProductVariationsModel.dart';
import '../Widgets/Product Grid/product_grid.dart';
import '../Widgets/shimmer/product_shimmer_widget.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({Key? key}) : super(key: key);

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  APIService? apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  final fieldText = TextEditingController();
  String initialSearchValue = '';
  List<String> searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final searchProduct = ref.watch(getProductBySearch(initialSearchValue));
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: kTitleColor,
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                height: 50,
                width: context.width(),
                decoration: BoxDecoration(
                  color: kBorderColorTextField.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: TextFormField(
                  controller: TextEditingController(),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Product',
                    fillColor: kBorderColorTextField,
                    focusColor: kMainColor,
                    suffixIcon: Icon(
                      FeatherIcons.search,
                      color: kTitleColor,
                    ),
                  ),
                  cursorColor: kTitleColor,
                  onTap: () {
                    setState(() {
                      initialSearchValue = '';
                    });
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      initialSearchValue = '';
                      initialSearchValue = value;
                      searchHistory.add(value);
                      TextEditingController().clear();
                    });
                  },
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Searches',
                          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              searchHistory.clear();
                              initialSearchValue = '';
                            });
                          },
                          child: Text(
                            'Clear All',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ),
                      ],
                    ).visible(searchHistory.isNotEmpty),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HorizontalList(
                        itemCount: searchHistory.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: kBorderColorTextField.withOpacity(0.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  searchHistory[index],
                                  style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                                  maxLines: 1,
                                ),
                                const SizedBox(width: 15.0),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searchHistory.removeAt(index);
                                      initialSearchValue = '';
                                    });
                                  },
                                  child: Icon(
                                    FeatherIcons.x,
                                    color: kGreyTextColor.withOpacity(0.5),
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  searchProduct.when(data: (snapshot) {
                    if (snapshot.isNotEmpty) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: snapshot.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return FutureBuilder<List<SingleProductVariations>>(
                              future: apiService?.getSingleProductVariation(snapshot[index].id!.toInt()),
                              builder: (context, snapData) {
                                if (snapData.hasData) {
                                  if (snapshot[index].type != 'simple' && snapData.data!.isNotEmpty) {
                                    int discount = discountGenerator(snapData.data![0].regularPrice.toString(), snapData.data![0].salePrice.toString());
                                    return BestSellingProduct(
                                        singleProductVariations: snapData.data![0], productModel: snapshot[index], discountPercentage: discount.toString(), isSingleView: false, categoryId: 0);
                                  } else {
                                    int discount = discountGenerator(snapshot[index].regularPrice.toString(), snapshot[index].salePrice.toString());
                                    return BestSellingProduct(
                                      productModel: snapshot[index],
                                      discountPercentage: discount.toString(),
                                      isSingleView: false,
                                      categoryId: 0,
                                    );
                                  }
                                } else {
                                  return Container();
                                }
                              });
                        },
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            'No item found',
                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const ProductGridShimmerWidget();
                  }).visible(initialSearchValue != ''),
                ],
              ),
            ),
          ),
        ),
      );
    });
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
