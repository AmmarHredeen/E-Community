import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/cart_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/cart_screen/shipping_screen.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(circleColor: redColor),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 60,
                  width: context.screenWidth - 60,
                  child: ourButten(
                      color: lightGolden,
                      textColor: darkFontGrey,
                      title: "Proseed to shopping",
                      onPress: () {
                        VxToast.show(context, msg: "Cart is Empty");
                      }),
                ),
              ),
              backgroundColor: white,
              appBar: AppBar(
                backgroundColor: redColor,
                automaticallyImplyLeading: false,
                title: "Shopping Cart".text.white.fontFamily(semibold).make(),
              ),
              body: Center(
                child: "Cart is Empty"
                    .text
                    .color(redColor)
                    .fontFamily(bold)
                    .make(),
              ),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;
            return Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 60,
                  width: context.screenWidth - 60,
                  child: ourButten(
                      color: redColor,
                      textColor: white,
                      title: "Proseed to shopping",
                      onPress: () {
                        Get.to(() => const ShippingDetails());
                      }),
                ),
              ),
              backgroundColor: white,
              appBar: AppBar(
                backgroundColor: redColor,
                automaticallyImplyLeading: false,
                title: "Shopping Cart".text.white.fontFamily(semibold).make(),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Image.network(
                              '${data[index]['img']}',
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            title:
                                '${data[index]['title']}     (${data[index]['qty']}X)'
                                    .text
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                            subtitle: '${data[index]['tprice']}'
                                .numCurrency
                                .text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                            trailing: const Icon(
                              Icons.delete,
                              color: redColor,
                            ).onTap(() {
                              FirestoreServices.deleteDocument(data[index].id);
                            }),
                          )
                              .box
                              .roundedSM
                              .margin(const EdgeInsets.symmetric(vertical: 4))
                              .color(lightGolden)
                              .make();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price :"
                            .text
                            .color(darkFontGrey)
                            .fontFamily(semibold)
                            .make(),
                        Obx(
                          () => '${controller.totalprice.value}'
                              .numCurrency
                              .text
                              .color(redColor)
                              .fontFamily(semibold)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(12))
                        .color(lightGolden)
                        .roundedSM
                        .width(context.screenWidth - 60)
                        .make(),
                  ],
                ),
              ),
            );
          }
        });
  }
}
