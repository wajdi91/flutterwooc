import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../Widgets/Product Grid/product_grid.dart';
import '../Widgets/shimmer/product_shimmer_widget.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({
    Key? key,
    required this.categoryId,
    required this.categoryModel,
    required this.categoryName,
    required this.categoryList,
  }) : super(key: key);

  final int categoryId;
  final CategoryModel categoryModel;
  final String categoryName;
  final List<CategoryModel> categoryList;

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  int selectedIndex = 0;
  APIService apiService = APIService();
  bool isSingleView = false;
  int subCategoryId = 0;

  FilterDataModel filterDataModel = FilterDataModel(
    selectedPrice: const SfRangeValues(0, 1000000),
    selectedSize: 'no data',
    selectedColor: 'no data',
    isFiltered: false,
  );

  List<int> priceList = [];
  List<ProductModel> filteredProduct = [];
  List<CategoryModel> categoryList = [];
  List<ProductModel> sortedProduct = [];
  List<String> variationsColor = [];
  List<String> variationsSize = [];
  String? sortValue;

  @override
  void initState() {
    categoryList.add(widget.categoryModel);
    for (var element in widget.categoryList) {
      if (element.parent == widget.categoryId) {
        categoryList.add(element);
      }
    }
    super.initState();
    subCategoryId = widget.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final allProducts = ref.watch(getProductOfSingleCategory(subCategoryId));
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1.0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              widget.categoryName,
              style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                HorizontalList(
                  spacing: 0,
                  itemCount: categoryList.length,
                  itemBuilder: (_, i) {
                    return categoryList[i].parent == widget.categoryId
                        ? GestureDetector(
                            onTap: () {
                              EasyLoading.show(status: isRtl ? HardcodedTextArabic.easyLoadingError : HardcodedTextEng.easyLoadingError,);
                              setState(() {
                                subCategoryId = categoryList[i].id!.toInt();
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: kGreyTextColor.withOpacity(0.2),
                                    ),
                                    color: subCategoryId == categoryList[i].id!.toInt() ? kMainColor : white,
                                  ),
                                  child: Text(
                                    categoryList[i].name ?? '',
                                    style: kTextStyle.copyWith(
                                      color: subCategoryId == categoryList[i].id!.toInt() ? white : kTitleColor,
                                    ),
                                  ),
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              EasyLoading.show(status: 'Loading');
                              setState(() {
                                subCategoryId = widget.categoryId.toInt();
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: kGreyTextColor.withOpacity(0.2),
                                    ),
                                    color: subCategoryId == categoryList[i].id!.toInt() ? kMainColor : white,
                                  ),
                                  child: Text(
                                    'All',
                                    style: kTextStyle.copyWith(
                                      color: subCategoryId == categoryList[i].id!.toInt() ? white : kTitleColor,
                                    ),
                                  ),
                                )),
                          );
                  },
                ).visible(categoryList.length > 1),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: allProducts.when(data: (snapshot) {
                    if (snapshot.isNotEmpty) {
                      EasyLoading.dismiss();

                      if (filterDataModel.isFiltered) {
                        final List<ProductModel> filteredProducts = [];

                        for (var elementSnapShot in snapshot) {
                          final allVariationProducts = ref.watch(getSingleProductVariation(elementSnapShot.id!.toInt()));
                          allVariationProducts.when(data: (snapData) {
                            for (var element in snapData) {
                              for (var elementAtt in element.attributes!) {
                                if (elementAtt.name?.toUpperCase() == 'COLOR') {
                                  if (!variationsColor.contains(elementAtt.option)) {
                                    variationsColor.add(elementAtt.option.toString());
                                  }
                                }
                                if (elementAtt.name?.toUpperCase() == 'SIZE') {
                                  if (!variationsSize.contains(elementAtt.option)) {
                                    variationsSize.add(elementAtt.option.toString());
                                  }
                                }
                              }
                            }
                            if (elementSnapShot.type != 'simple') {
                              bool showVariationProduct = false;
                              for (var element in snapData) {
                                int numberOfTrue = 0;
                                for (var elementAtt in element.attributes!) {
                                  if (elementAtt.option == filterDataModel.selectedColor) numberOfTrue++;
                                  if (elementAtt.option == filterDataModel.selectedSize) numberOfTrue++;
                                }
                                if (filterDataModel.selectedColor != 'no data' && filterDataModel.selectedSize != 'no data' && numberOfTrue == 2) {
                                  showVariationProduct = true;
                                } else if (filterDataModel.selectedColor == 'no data' && filterDataModel.selectedSize == 'no data') {
                                  showVariationProduct = true;
                                }
                              }
                              if (snapData[0].salePrice.toInt().isBetween(filterDataModel.selectedPrice.start, filterDataModel.selectedPrice.end) &&
                                  (filterDataModel.isFiltered ? showVariationProduct : true)) {
                                filteredProducts.add(elementSnapShot);
                              }
                            } else {
                              if (elementSnapShot.salePrice.toInt().isBetween(filterDataModel.selectedPrice.start, filterDataModel.selectedPrice.end) &&
                                  filterDataModel.selectedColor == 'no data' &&
                                  filterDataModel.selectedSize == 'no data') {
                                filteredProducts.add(elementSnapShot);
                              }
                            }
                          }, error: (e, stack) {
                            return Text(e.toString());
                          }, loading: () {
                            return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: context.width() / 2,
                                  width: context.width() / 2.2,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), border: Border.all(color: white)),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 150.0,
                                        width: context.width() / 2,
                                        decoration: const BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        height: 18,
                                        width: 150,
                                        decoration: const BoxDecoration(
                                          color: white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        height: 14,
                                        width: 130,
                                        decoration: const BoxDecoration(
                                          color: white,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Container(
                                        height: 14,
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          });
                        }
                        if (filteredProducts.isNotEmpty) {
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.65,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return BestSellingProduct(
                                productModel: filteredProducts[index],
                                discountPercentage: 0.toString(),
                                isSingleView: isSingleView,
                                categoryId: widget.categoryId,
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('No Product Found'));
                        }
                      } else {
                        return GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isSingleView ? 1 : 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: isSingleView ? 0.65 : 0.65,
                          ),
                          itemCount: snapshot.length,
                          itemBuilder: (BuildContext ctx, index) {
                            final allVariationProducts = ref.watch(getSingleProductVariation(snapshot[index].id!.toInt()));
                            return allVariationProducts.when(data: (snapData) {
                              for (var element in snapData) {
                                for (var elementAtt in element.attributes!) {
                                  if (elementAtt.name?.toUpperCase() == 'COLOR') {
                                    if (!variationsColor.contains(elementAtt.option)) {
                                      variationsColor.add(elementAtt.option.toString());
                                    }
                                  }
                                  if (elementAtt.name?.toUpperCase() == 'SIZE') {
                                    if (!variationsSize.contains(elementAtt.option)) {
                                      variationsSize.add(elementAtt.option.toString());
                                    }
                                  }
                                }
                              }
                              if (snapshot[index].type != 'simple' && snapData.isNotEmpty) {
                                for (var element in snapData) {
                                  int numberOfTrue = 0;
                                  for (var elementAtt in element.attributes!) {
                                    if (elementAtt.option == filterDataModel.selectedColor) numberOfTrue++;
                                    if (elementAtt.option == filterDataModel.selectedSize) numberOfTrue++;
                                  }
                                  if (filterDataModel.selectedColor != 'no data' && filterDataModel.selectedSize != 'no data' && numberOfTrue == 2) {
                                  } else if (filterDataModel.selectedColor == 'no data' && filterDataModel.selectedSize == 'no data') {
                                  }
                                }
                                int discount = discountGenerator(snapData[0].regularPrice.toString(), snapData[0].salePrice.toString());
                                return BestSellingProduct(
                                  singleProductVariations: snapData[0],
                                  productModel: snapshot[index],
                                  discountPercentage: discount.toString(),
                                  isSingleView: isSingleView,
                                  categoryId: widget.categoryId,
                                );
                              } else {
                                int discount = discountGenerator(snapshot[index].regularPrice.toString(), snapshot[index].salePrice.toString());
                                return BestSellingProduct(
                                  productModel: snapshot[index],
                                  discountPercentage: discount.toString(),
                                  isSingleView: isSingleView,
                                  categoryId: widget.categoryId,
                                );
                              }
                            }, error: (e, stack) {
                              return Text(e.toString());
                            }, loading: () {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: context.width() / 2,
                                    width: context.width() / 2.2,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), border: Border.all(color: white)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150.0,
                                          width: context.width() / 2,
                                          decoration: const BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          height: 18,
                                          width: 150,
                                          decoration: const BoxDecoration(
                                            color: white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Container(
                                          height: 14,
                                          width: 130,
                                          decoration: const BoxDecoration(
                                            color: white,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Container(
                                          height: 14,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            color: white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                          },
                        );
                      }
                    } else {
                      EasyLoading.dismiss();
                      return const Center(child: Text('No Product Found'));
                    }
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const ProductGridShimmerWidget();
                  }),
                ),
              ],
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

class FilterDataModel {
  FilterDataModel({required this.selectedPrice, required this.selectedColor, required this.selectedSize, required this.isFiltered});

  String selectedColor;
  String selectedSize;
  SfRangeValues selectedPrice;
  bool isFiltered;
}
