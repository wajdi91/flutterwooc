import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:my_bazar/Screens/Home%20Screen/product_details.dart';
import 'package:my_bazar/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api_service/api_service.dart';
import '../../models/product_model.dart';
import '../../models/wishlist_model.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Wishlist> wishList = [];
  APIService? apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  double initialRating = 0;

  Future<List<Wishlist>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('wishListProducts');
    final decodedData = Wishlist.decode(data!);
    setState(() {});
    return decodedData;
  }

  void removeItem(var id) async {
    wishList.removeWhere((element) => element.id == id);
    final prefs = await SharedPreferences.getInstance();
    String encodedData = Wishlist.encode(wishList);
    prefs.setString('wishListProducts', encodedData);
    setState(() {});

    return null;
  }

  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kTitleColor),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Wishlist (${wishList.length})',
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
              width: context.width(),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: getData(),
                      builder: (_, AsyncSnapshot<List<Wishlist>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: wishList.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder<List<ProductModel>>(
                                  future: apiService!.getProductOfCategory(snapshot.data![index].categoryId!),
                                  builder: (context, snapData) {
                                    if (snapData.hasData) {
                                      return GestureDetector(
                                        onTap: () {
                                          ProductDetails(
                                            productModel: snapData.data![index],
                                            categoryId: snapshot.data![index].categoryId!.toInt(),
                                          ).launch(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            right: 8,
                                            bottom: 8,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              border: Border.all(
                                                width: 1,
                                                color: kBorderColorTextField,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    height: 110,
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: kBorderColorTextField,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                      color: kBorderColorTextField,
                                                      image: DecorationImage(image: NetworkImage(snapshot.data![index].img.toString())),
                                                    ),
                                                  ),
                                                ),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  SizedBox(
                                                    width: context.width() / 1.8,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: context.width() / 2.2,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: SizedBox(
                                                              child: Text(
                                                                snapshot.data![index].name.toString(),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            var id = snapshot.data![index].id;
                                                            removeItem(id);
                                                          },
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: kMainColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Text(
                                                      '${snapshot.data![index].price}\$',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: context.width() / 1.8,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            RatingBarWidget(
                                                              rating: initialRating,
                                                              activeColor: ratingColor,
                                                              inActiveColor: ratingColor,
                                                              size: 16,
                                                              onRatingChanged: (aRating) {
                                                                setState(() {
                                                                  initialRating = aRating;
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(width: 5),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            color: kMainColor.withOpacity(0.05),
                                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                          ),
                                                          child: const Center(
                                                              child: Icon(
                                                            IconlyLight.bag,
                                                            color: kMainColor,
                                                          )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ])
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  });
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('No Product Found'),
                          );
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
