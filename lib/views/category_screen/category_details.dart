import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/controller/product_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/category_screen/item_details.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/bg_widget.dart';
import 'package:e_community/consts/consts.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();

  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.fontFamily(bold).white.make(),
          leading: const Icon(
            Icons.arrow_back,
            color: white,
          ).onTap(() {
            Get.back();
          }),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    controller.subcat.length,
                    (index) => "${controller.subcat[index]}"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .size(12)
                            .makeCentered()
                            .box
                            .white
                            .size(120, 50)
                            .rounded
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .make()
                            .onTap(() {
                          switchCategory("${controller.subcat[index]}");
                          setState(() {});
                        })),
              ),
            ),
            20.heightBox,
            StreamBuilder(
                stream: productMethod,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      child: Center(
                        child: loadingIndicator(circleColor: redColor),
                      ),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Expanded(
                      child: "No products found !"
                          .text
                          .color(darkFontGrey)
                          .makeCentered(),
                    );
                  } else {
                    var data = snapshot.data!.docs;
                    //! Items Container

                    return Expanded(
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 250,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  data[index]['p_image'][0],
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                "${data[index]['p_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                10.heightBox,
                                "${data[index]['p_price']}"
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
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .outerShadowSm
                                .padding(const EdgeInsets.all(12))
                                .make()
                                .onTap(() {
                              controller.checkIfFav(data[index]);
                              Get.to(ItemDetails(
                                  cat: "${data[index]['p_subcategory']}",
                                  title: "${data[index]['p_name']}",
                                  data: data[index]));
                            });
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
