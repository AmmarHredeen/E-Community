import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/product_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/products_shop_screens/edit_product.dart';
import 'package:e_community/widgets_common/custom_textfield_for_shop.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/views/products_shop_screens/add_product.dart';
import 'package:e_community/views/products_shop_screens/product_details.dart';
import 'package:e_community/widgets_common/appbar_widget.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        backgroundColor: purpleColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: FirestoreServices.getProductShop(),
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
                  children: List.generate(
                    data.length,
                    (index) => Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ProductDetails(data: data[index]));
                        },
                        leading: Image.network(
                          data[index]['p_image'][0],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            boldText(
                                text: "${data[index]['p_name']}",
                                color: purpleColor),
                            20.widthBox,
                            boldText(
                                text: data[index]['is_featured'] == true
                                    ? "Featured"
                                    : '',
                                color: green),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            normalText(
                                text: "${data[index]['p_price']} \$",
                                color: redColor),
                            10.widthBox,
                            boldText(
                                text: data[index]['is_deal'] != '0'
                                    ? "Deal (${data[index]['is_deal']})"
                                    : '',
                                color: Colors.purple),
                          ],
                        ),
                        trailing: VxPopupMenu(
                          arrowSize: 0.0,
                          menuBuilder: () => Column(
                            children: List.generate(
                              popupMenuTitles.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      popupMenuIcons[i],
                                      color: data[index]['featured_id'] ==
                                                  currentUser!.uid &&
                                              i == 0
                                          ? green
                                          : data[index]['is_deal'] != '0' &&
                                                  i == 1
                                              ? Colors.purple
                                              : darkGrey,
                                    ),
                                    10.widthBox,
                                    normalText(
                                        text: data[index]['featured_id'] ==
                                                    currentUser!.uid &&
                                                i == 0
                                            ? "Remove featured"
                                            : data[index]['is_deal'] != '0' &&
                                                    i == 1
                                                ? "Remove Deal"
                                                : popupMenuTitles[i],
                                        color: darkGrey)
                                  ],
                                ).onTap(() async {
                                  switch (i) {
                                    case 0:
                                      if (data[index]['is_featured'] == true) {
                                        controller
                                            .removeFeatured(data[index].id);
                                        VxToast.show(context, msg: 'Removed');
                                      } else {
                                        controller.addFeatured(data[index].id);
                                        VxToast.show(context, msg: 'Added');
                                      }
                                      break;
                                    case 1:
                                      if (data[index]['is_deal'] != '0') {
                                        controller.removeDeal(data[index].id);
                                        VxToast.show(context,
                                            msg: 'Removed Discount');
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                    backgroundColor:
                                                        purpleColor,
                                                    title: const Text(
                                                      'Deal',
                                                      style: TextStyle(
                                                          color: white,
                                                          fontFamily: bold),
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Add the discount value",
                                                          style: TextStyle(
                                                              color: white),
                                                        ),
                                                        10.heightBox,
                                                        customTextFieldForShop(
                                                            controller: controller
                                                                .dealController,
                                                            hint: "value",
                                                            label:
                                                                'Discount value'),
                                                      ],
                                                    ).box.height(100).make(),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Close",
                                                            style: TextStyle(
                                                                color: white),
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await controller
                                                                .addDeal(
                                                                    data[index]
                                                                        .id,
                                                                    controller
                                                                        .dealController
                                                                        .text);

                                                            // ignore: use_build_context_synchronously
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Save",
                                                            style: TextStyle(
                                                                color: white),
                                                          ))
                                                    ]));
                                      }
                                      break;
                                    case 2:
                                      await controller.getCategories();
                                      controller.populateCategoryList();
                                      controller.pnameController.text =
                                          data[index]['p_name'];
                                      controller.pdescController.text =
                                          data[index]['p_desc'];
                                      controller.ppriceController.text =
                                          data[index]['p_price'];
                                      controller.pquantityController.text =
                                          data[index]['p_quantity'];
                                      controller.categoryvalue.value =
                                          data[index]['p_category'];
                                      controller.subcategoryvalue.value =
                                          data[index]['p_subcategory'];

                                      for (var i = 0;
                                          i < data[index]['p_image'].length;
                                          i++) {
                                        controller.pImagesLinks
                                            .add(data[index]['p_image'][i]);
                                      }

                                      for (var i = 0;
                                          i < data[index]['p_colors'].length;
                                          i++) {
                                        for (var j = 0;
                                            j < data[index]['p_colors'].length;
                                            j++) {
                                          if (data[index]['p_colors'][i] ==
                                              productColors[j]) {
                                            controller.selectedColorIndex[j] =
                                                productColors[j];
                                          }
                                        }
                                      }
                                      Get.to(
                                          EditProduct(docID: data[index].id));
                                      break;
                                    case 3:
                                      controller.removeProduct(data[index].id);
                                      VxToast.show(context,
                                          msg: 'Product removed');
                                      break;
                                  }
                                }),
                              ),
                            ),
                          ).box.white.rounded.width(200).make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
