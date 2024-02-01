import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/shop_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/orders_shop_screens/orders_screen.dart';
import 'package:e_community/views/shop_screen/shop_settings_screen.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/views/products_shop_screens/product_details.dart';
import 'package:e_community/views/products_shop_screens/products_screen.dart';
import 'package:e_community/widgets_common/appbar_widget.dart';
import 'package:e_community/widgets_common/dashboard_button.dart';
import 'package:get/get.dart';

class HomeShopScreen extends StatelessWidget {
  const HomeShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ShopController>();

    return Scaffold(
      backgroundColor: white,
      appBar: appbarWidget(myShop),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            10.heightBox,
            FutureBuilder(
                future: FirestoreServices.getShop(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return loadingIndicator(circleColor: white);
                  } else {
                    var data = snapshot.data!.docs[0];
                    return Column(
                      children: [
                        10.heightBox,
                        boldText(
                            text: data['shop_name'],
                            color: purpleColor,
                            size: 22.0),
                        20.heightBox,
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            ListTile(
                              onTap: () {
                                controller.shopNameConroller.text =
                                    data['shop_name'];
                                controller.shopAddressConroller.text =
                                    data['shop_address'];
                                controller.shopMobilConroller.text =
                                    data['shop_mobile'];
                                controller.shopWebsiteConroller.text =
                                    data['shop_website'];
                                controller.shopDescConroller.text =
                                    data['shop_desc'];
                                controller.sellerPolicyConroller.text =
                                    data['seller_policy'];
                                controller.returnPolicyConroller.text =
                                    data['return_policy'];
                                controller.supportPolicyConroller.text =
                                    data['support_policy'];
                                Get.to(() => const ShopSettings());
                              },
                              leading: Image.asset(
                                icShopSettings,
                                color: purpleColor,
                              ),
                              title: normalText(
                                  text: shopSetting,
                                  color: purpleColor,
                                  size: 16.0),
                            ),
                          ]),
                        )
                      ],
                    );
                  }
                }),
            const Divider(),
            10.heightBox,
            StreamBuilder(
              stream: FirestoreServices.getProductShop(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return loadingIndicator();
                } else {
                  var data = snapshot.data!.docs;

                  data = data.sortedBy((a, b) =>
                      b['p_wishlist'].length.compareTo(a['p_wishlist'].length));

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(
                              context,
                              title: products,
                              count: "${data.length}",
                              icon: icProducts,
                            ).onTap(() {
                              Get.to(() => const ProductsScreen());
                            }),
                            StreamBuilder(
                              stream: FirestoreServices.getOrdersShop(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return loadingIndicator();
                                } else {
                                  var order = snapshot.data!.docs;
                                  return dashboardButton(context,
                                          title: orders,
                                          count: "${order.length}",
                                          icon: icOrders)
                                      .onTap(() {
                                    Get.to(() => const OrdersShopScreen());
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        // 10.heightBox,
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     dashboardButton(context,
                        //         title: rating, count: "60", icon: icStar),
                        //     dashboardButton(context,
                        //         title: totalSales, count: "15", icon: icOrders),
                        //   ],
                        // ),
                        10.heightBox,
                        const Divider(),
                        10.heightBox,
                        boldText(text: popular, color: darkGrey, size: 16.0),
                        20.heightBox,
                        ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                            data.length,
                            (index) => data[index]['p_wishlist'].length == 0
                                ? const SizedBox()
                                : Card(
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(() =>
                                            ProductDetails(data: data[index]));
                                      },
                                      leading: Image.network(
                                        data[index]['p_image'][0],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          boldText(
                                              text: "${data[index]['p_name']}",
                                              color: purpleColor),
                                          boldText(
                                              text: data[index]
                                                          ['is_featured'] ==
                                                      true
                                                  ? "Featured"
                                                  : '',
                                              color: green),
                                        ],
                                      ),
                                      subtitle: normalText(
                                          text: "${data[index]['p_price']} \$",
                                          color: redColor),
                                      trailing:
                                          const Icon(Icons.arrow_circle_right),
                                    )
                                        .box
                                        .rounded
                                        .margin(
                                            const EdgeInsets.only(bottom: 4))
                                        .make(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
