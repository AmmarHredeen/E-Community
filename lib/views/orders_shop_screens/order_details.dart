import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/orders_controller.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/views/orders_screen/components/order_place_details.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
    controller.activeOrder(docID: widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: purpleColor,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: white,
              )),
          title: boldText(text: "Order Details", color: white, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButten(
                textColor: white,
                color: green,
                onPress: () {
                  controller.confirmed(true);
                  controller.changeStatus(
                      title: "order_confirmed",
                      status: true,
                      docID: widget.data.id);
                },
                title: "Confirm Order"),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //! Order Delvery Status Sction

              Visibility(
                visible: controller.confirmed.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(
                        text: "Order Status :", color: fontGrey, size: 16.0),
                    SwitchListTile(
                      activeColor: green,
                      value: true,
                      onChanged: (value) {},
                      title: boldText(text: "Placed", color: fontGrey),
                    ),
                    SwitchListTile(
                      activeColor: green,
                      value: controller.confirmed.value,
                      onChanged: (value) {
                        controller.confirmed.value = value;
                      },
                      title: boldText(text: "Confirmed", color: fontGrey),
                    ),
                    SwitchListTile(
                      activeColor: green,
                      value: controller.ondelivery.value,
                      onChanged: (value) {
                        controller.ondelivery.value = value;
                        controller.changeStatus(
                            title: "order_on_delivery",
                            status: value,
                            docID: widget.data.id);
                      },
                      title: boldText(text: "On Delivery", color: fontGrey),
                    ),
                    SwitchListTile(
                      activeColor: green,
                      value: controller.delivered.value,
                      onChanged: (value) {
                        controller.delivered.value = value;
                        controller.changeStatus(
                            title: "order_delivered",
                            status: value,
                            docID: widget.data.id);
                      },
                      title: boldText(text: "Delivered", color: fontGrey),
                    ),
                  ],
                )
                    .box
                    .padding(const EdgeInsets.all(8.0))
                    .outerShadowMd
                    .white
                    .border(color: lightGrey)
                    .roundedSM
                    .make(),
              ),

              //! Order Details Sction
              Column(
                children: [
                  orderPlaceDetails(
                      title1: "Order Code",
                      title2: "Shipping Method",
                      d1: "${widget.data['order_code']}",
                      d2: "${widget.data['shipping_method']}"),
                  orderPlaceDetails(
                      title1: "Order Date",
                      title2: "Payment Method",
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format(widget.data['order_date'].toDate()),
                      d2: "${widget.data['payment_method']}"),
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
                            boldText(
                                text: "Sipping Address", color: purpleColor),
                            "${widget.data['order_by_name']}".text.make(),
                            "${widget.data['order_by_email']}".text.make(),
                            "${widget.data['order_by_address']}".text.make(),
                            "${widget.data['order_by_city']}".text.make(),
                            "${widget.data['order_by_phone']}".text.make(),
                            "${widget.data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              boldText(
                                  text: "Total Amount", color: purpleColor),
                              boldText(
                                  text: "${widget.data['total_amount']} \$",
                                  color: red,
                                  size: 16.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  .box
                  .outerShadowMd
                  .white
                  .border(color: lightGrey)
                  .roundedSM
                  .make(),
              const Divider(color: white),
              10.heightBox,
              boldText(text: "Order products", color: fontGrey),
              10.heightBox,
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(controller.orders.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: "${controller.orders[index]['title']}",
                        title2: "${controller.orders[index]['tprice']} \$",
                        d1: "${controller.orders[index]['qty']} x ",
                        d2: "Refoundable",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 20,
                          width: 30,
                          color: Color(controller.orders[index]['color']),
                        ),
                      ),
                      const Divider(
                        color: white,
                      ),
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
