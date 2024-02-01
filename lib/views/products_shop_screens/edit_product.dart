import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/product_controller.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/views/products_shop_screens/components/product_dropdown.dart';
import 'package:e_community/widgets_common/custom_textfield_for_shop.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EditProduct extends StatefulWidget {
  String? docID;
  EditProduct({super.key, required this.docID});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: white,
              )),
          title: boldText(text: "Edit Product", color: white, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.editProduct(context, widget.docID);
                    },
                    child: boldText(text: "Save", color: white))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextFieldForShop(
                    hint: "eg. BMW",
                    label: "Product name",
                    controller: controller.pnameController),
                25.heightBox,
                customTextFieldForShop(
                    hint: "eg. Nice product",
                    label: "Description",
                    isDesc: true,
                    controller: controller.pdescController),
                25.heightBox,
                customTextFieldForShop(
                    hint: "eg. 100.00 \$",
                    label: "Price",
                    controller: controller.ppriceController),
                25.heightBox,
                customTextFieldForShop(
                    hint: "eg. 20",
                    label: "Quantity",
                    controller: controller.pquantityController),
                25.heightBox,
                productDropdown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                25.heightBox,
                productDropdown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
                25.heightBox,
                const Divider(),
                // boldText(text: "Choose product images :"),
                // 25.heightBox,
                // Obx(
                //   () => Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: List.generate(
                //         3,
                //         (index) => controller.pImagesList[index] != null
                //             ? Image.file(
                //                 controller.pImagesList[index],
                //                 width: 100,
                //               ).onTap(() {
                //                 controller.pickImage(index, context);
                //               })
                //             : Image.network(
                //                 Get.find<ProductController>()
                //                     .pImagesLinks[index],
                //                 width: 100,
                //               ).onTap(() {
                //                 controller.pickImage(index, context);
                //               })

                //         ),
                //   ),
                // ),
                // 10.heightBox,
                // normalText(
                //     text: "First image will be your display image", color: red),
                // 20.heightBox,
                // const Divider(),
                25.heightBox,
                boldText(text: "Choose product colors :"),
                20.heightBox,
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                      productColors.length,
                      (index) => Stack(
                            alignment: Alignment.center,
                            children: [
                              VxBox()
                                  .color(Color(productColors[index]))
                                  .roundedFull
                                  .size(70, 70)
                                  .make()
                                  .onTap(() {
                                setState(() {
                                  controller.selectedColorIndex[index] ==
                                          Colors.amber.value
                                      ? controller.selectedColorIndex[index] =
                                          productColors[index]
                                      : controller.selectedColorIndex[index] =
                                          Colors.amber.value;
                                });
                              }),
                              controller.selectedColorIndex[index] !=
                                      Colors.amber.value
                                  ? Icon(Icons.done,
                                      color: index == 0 ? Colors.black : white)
                                  : const SizedBox(),
                            ],
                          )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
