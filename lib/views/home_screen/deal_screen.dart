import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/category_screen/item_details.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/bg_widget.dart';
import 'package:get/get.dart';

class DealScreen extends StatelessWidget {
  const DealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: 'Today\'s Deal'.text.white.bold.make(),
          leading: const Icon(Icons.arrow_back, color: white).onTap(() {
            Get.back();
          }),
        ),
        body: Container(
          height: context.screenHeight,
          color: redColor,
          child: StreamBuilder(
              stream: FirestoreServices.getDealProducts(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: loadingIndicator(),
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
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 4),
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
                              5.heightBox,
                              Row(
                                children: [
                                  "${data[index]['p_price']}"
                                      .numCurrency
                                      .text
                                      .lineThrough
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(14)
                                      .make(),
                                  " \$"
                                      .text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(14)
                                      .make(),
                                ],
                              ),
                              5.heightBox,
                              Row(
                                children: [
                                  "${int.parse(data[index]['p_price']) - int.parse(data[index]['is_deal'])}"
                                      .numCurrency
                                      .text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(16)
                                      .make(),
                                  " \$"
                                      .text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(16)
                                      .make(),
                                ],
                              ),
                            ],
                          )
                              .box
                              .white
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .outerShadowSm
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            Get.to(ItemDetails(
                                cat: "${data[index]['p_subcategory']}",
                                title: "${data[index]['p_name']}",
                                data: data[index]));
                          });
                        }),
                  );
                }
              }),
        ),
      ),
    );
  }
}
