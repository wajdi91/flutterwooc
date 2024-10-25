import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_bazar/Providers/all_repo_providers.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Config/hardcoded_text.dart';
import '../../Config/hardcoded_text_arabic.dart';
import '../../api_service/api_service.dart';
import '../../constant.dart';
import '../Widgets/shimmer/order_page_shimmer.dart';
import 'category_product.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late APIService apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final allCategory = ref.watch(getAllCategories);
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1.0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              isRtl ? HardcodedTextArabic.categories : HardcodedTextEng.categories,
              style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                allCategory.when(data: (snapShot) {
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15.0,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 15.0,
                      ),
                      itemCount: snapShot.length,
                      itemBuilder: (_, index) {
                        String image = snapShot[index].image?.src.toString() ??
                            'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f';
                        return CategoryView(
                          name: snapShot[index].name.toString(),
                          image: image,
                          onTabFunction: () {
                            CategoryProduct(
                              categoryId: snapShot[index].id!.toInt(),
                              categoryName: snapShot[index].name.toString(),
                              categoryList: snapShot,
                              categoryModel: snapShot[index],
                            ).launch(context);
                          },
                        );
                      },
                    ),
                  );
                }, error: (e, stack) {
                  return Text(e.toString());
                }, loading: () {
                  return const CategoryPageShimmer();
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    Key? key,
    required this.name,
    required this.image,
    required this.onTabFunction,
  }) : super(key: key);
  final String name;
  final String image;
  final VoidCallback onTabFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTabFunction,
      child: Column(
        children: [
          Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Center(
            child: Text(
              name,
              style: kTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
