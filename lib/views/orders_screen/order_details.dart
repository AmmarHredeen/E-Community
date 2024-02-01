import 'package:e_community/consts/consts.dart';
import 'package:e_community/views/orders_screen/components/order_place_details.dart';
import 'package:e_community/views/orders_screen/components/order_status.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redColor,
        title: "Order Details".text.color(white).fontFamily(semibold).make(),
        leading: const Icon(
          Icons.arrow_back,
          color: white,
        ).onTap(() {
          Get.back();
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                color: redColor,
                icon: Icons.done,
                title: "Placed",
                showDone: data['order_placed'],
              ),
              orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Confirmed",
                showDone: data['order_confirmed'],
              ),
              orderStatus(
                color: Colors.yellow,
                icon: Icons.car_crash,
                title: "On Delivery",
                showDone: data['order_on_delivery'],
              ),
              orderStatus(
                color: Colors.purple,
                icon: Icons.done_all_rounded,
                title: "Delivered",
                showDone: data['order_delivered'],
              ),
              const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                      title1: "Order Code",
                      title2: "Shipping Method",
                      d1: data['order_code'],
                      d2: data['shipping_method']),
                  orderPlaceDetails(
                      title1: "Order Date",
                      title2: "Payment Method",
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format(data['order_date'].toDate()),
                      d2: data['payment_method']),
                  orderPlaceDetails(
                      title1: "Payment Status",
                      title2: "Delivery Status",
                      d1: "Unpaid",
                      d2: "Order Placed"),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Sipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(redColor)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(color: white),
              10.heightBox,
              "Ordered Product"
                  .text
                  .fontFamily(semibold)
                  .color(darkFontGrey)
                  .size(16)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['orders'][index]['tprice'],
                        d1: "${data['orders'][index]['qty']} x ",
                        d2: "Refoundable",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 20,
                          width: 30,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                      const Divider(color: white),
                    ],
                  );
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
