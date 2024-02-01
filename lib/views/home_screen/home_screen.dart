import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/home_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/category_screen/item_details.dart';
import 'package:e_community/views/home_screen/components/features_button.dart';
import 'package:e_community/views/home_screen/deal_screen.dart';
import 'package:e_community/views/home_screen/popular_product.dart';
import 'package:e_community/views/home_screen/search_screen.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/home_buttons.dart';
import 'package:get/get.dart';

class HomeScereen extends StatelessWidget {
  const HomeScereen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                cursorColor: redColor,
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: redColor,
                  ).onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearchScreen(
                            title: controller.searchController.text,
                          ));
                    }
                  }),
                  filled: true,
                  fillColor: white,
                  hintText: searchAnything,
                  helperStyle: const TextStyle(
                    color: redColor,
                  ),
                ),
              ).box.rounded.make(),
            ),

            //! Swiper Brands
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 175,
                      enlargeCenterPage: true,
                      itemCount: slidesList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          slidesList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 12))
                            .make();
                      },
                    ),

                    // //! Home Buttons
                    10.heightBox,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            2,
                            (index) => homeButton(
                                  height: context.screenHeight * 0.15,
                                  width: context.screenWidth / 2.5,
                                  icon: index == 0 ? icTodaysDeal : icTopSeller,
                                  title: index == 0 ? todayDeal : popular,
                                ).onTap(() {
                                  index == 0
                                      ? Get.to(() => const DealScreen())
                                      : Get.to(() => const PopularProduct());
                                }))),

                    //! featured product
                    10.heightBox,
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: redColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: loadingIndicator(),
                                  );
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "No Featured Products"
                                      .text
                                      .white
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;

                                  return Row(
                                    children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_image'][0],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(darkFontGrey)
                                              .make(),
                                          10.heightBox,
                                          "${featuredData[index]['p_price']}"
                                              .numCurrency
                                              .text
                                              .color(redColor)
                                              .fontFamily(bold)
                                              .size(15)
                                              .make(),
                                        ],
                                      )
                                          .box
                                          .white
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .roundedSM
                                          .padding(const EdgeInsets.all(8))
                                          .make()
                                          .onTap(() {
                                        Get.to(
                                          () => ItemDetails(
                                            cat:
                                                "${featuredData[index]['p_category']}",
                                            title:
                                                "${featuredData[index]['p_name']}",
                                            data: featuredData[index],
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    //! Featured Categories
                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              featurButton(
                                  icon: featuredImages1[index],
                                  title: featuredTitle1[index]),
                              10.heightBox,
                              featurButton(
                                  icon: featuredImages2[index],
                                  title: featuredTitle2[index]),
                            ],
                          ),
                        ).toList(),
                      ),
                    ),

                    //! All Peoducts Section
                    20.heightBox,
                    StreamBuilder(
                        stream: FirestoreServices.allProducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return loadingIndicator(circleColor: redColor);
                          } else {
                            var allProductsdata = snapshot.data!.docs;
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allProductsdata.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      mainAxisExtent: 300),
                              itemBuilder: (context, index) {
                                controller
                                    .calculateRating(allProductsdata[index]);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      allProductsdata[index]['p_image'][0],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    const Spacer(),
                                    "${allProductsdata[index]['p_name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                    // allProductsdata[index]['is_deal'] == '0'
                                    //     ? const SizedBox()
                                    //     : Row(
                                    //         children: [
                                    //           "${allProductsdata[index]['p_price']}"
                                    //               .numCurrency
                                    //               .text
                                    //               .lineThrough
                                    //               .color(redColor)
                                    //               .fontFamily(bold)
                                    //               .size(15)
                                    //               .make(),
                                    //           " \$"
                                    //               .text
                                    //               .color(redColor)
                                    //               .fontFamily(bold)
                                    //               .size(15)
                                    //               .make()
                                    //         ],
                                    //       ),
                                    Row(
                                      children: [
                                        "${int.parse(allProductsdata[index]['p_price'])}"
                                            .numCurrency
                                            .text
                                            .color(redColor)
                                            .fontFamily(bold)
                                            .size(15)
                                            .make(),
                                        " \$"
                                            .text
                                            .color(redColor)
                                            .fontFamily(bold)
                                            .size(15)
                                            .make()
                                      ],
                                    ),
                                  ],
                                )
                                    .box
                                    .white
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .roundedSM
                                    .padding(const EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  Get.to(
                                    () => ItemDetails(
                                      cat:
                                          "${allProductsdata[index]['p_category']}",
                                      title:
                                          "${allProductsdata[index]['p_name']}",
                                      data: allProductsdata[index],
                                    ),
                                  );
                                });
                              },
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
