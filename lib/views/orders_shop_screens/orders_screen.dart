import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/orders_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/views/orders_shop_screens/order_details.dart';
import 'package:e_community/widgets_common/appbar_widget.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrdersShopScreen extends StatelessWidget {
  const OrdersShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controller = Get.put(OrdersController());
    return Scaffold(
      backgroundColor: white,
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: FirestoreServices.getOrdersShop(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var time = data[index]['order_date'].toDate();
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => OrderDetails(
                                data: data[index],
                              ));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: boldText(
                            text: "${data[index]['order_code']}",
                            color: purpleColor),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: fontGrey,
                                ),
                                10.widthBox,
                                boldText(
                                    text: intl.DateFormat()
                                        .add_yMd()
                                        .format(time),
                                    color: fontGrey),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.payment,
                                  color: fontGrey,
                                ),
                                10.widthBox,
                                normalText(text: unpaid, color: red),
                              ],
                            ),
                          ],
                        ),
                        trailing: boldText(
                            text: "${data[index]['total_amount']} \$",
                            color: purpleColor,
                            size: 16.0),
                      ).box.margin(const EdgeInsets.only(bottom: 4)).make(),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
