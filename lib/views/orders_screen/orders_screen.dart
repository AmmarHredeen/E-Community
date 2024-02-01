import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/orders_screen/order_details.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redColor,
        title: "My Orders".text.color(white).fontFamily(semibold).make(),
        leading: const Icon(
          Icons.arrow_back,
          color: white,
        ).onTap(() {
          Get.back();
        }),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllOreders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(circleColor: redColor),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No Orders Yet!".text.color(redColor).makeCentered();
            } else {
              var data = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: "${index + 1}"
                            .text
                            .color(darkFontGrey)
                            .fontFamily(bold)
                            .xl
                            .make(),
                        title: data[index]['order_code']
                            .toString()
                            .text
                            .color(redColor)
                            .fontFamily(semibold)
                            .make(),
                        subtitle: data[index]['total_amount']
                            .toString()
                            .numCurrency
                            .text
                            .fontFamily(bold)
                            .make(),
                        trailing: IconButton(
                            onPressed: () {
                              Get.to(() => OrdersDetails(data: data[index]));
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: darkFontGrey,
                            )),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
