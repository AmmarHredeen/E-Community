import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/category_screen/item_details.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redColor,
        title: "My Wishlist".text.color(white).fontFamily(semibold).make(),
        leading: const Icon(
          Icons.arrow_back,
          color: white,
        ).onTap(() {
          Get.back();
        }),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllWishlist(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(circleColor: redColor),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No Wishlist Yet!".text.color(redColor).makeCentered();
            } else {
              var data = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          // color: lightGolden,
                          child: ListTile(
                            onTap: () {
                              Get.to(ItemDetails(
                                  data: data[index],
                                  title: data[index]['p_name'],
                                  cat: data[index]['p_category']));
                            },
                            leading: Image.network(
                              '${data[index]['p_image'][0]}',
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            title: '${data[index]['p_name']}'
                                .text
                                .fontFamily(semibold)
                                .size(16)
                                .make(),
                            subtitle: '${data[index]['p_price']}'
                                .numCurrency
                                .text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                            trailing: const Icon(
                              Icons.favorite,
                              color: redColor,
                            ).onTap(() async {
                              await firestore
                                  .collection(productsCollection)
                                  .doc(data[index].id)
                                  .set({
                                'p_wishlist':
                                    FieldValue.arrayRemove([currentUser!.uid])
                              }, SetOptions(merge: true));
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
