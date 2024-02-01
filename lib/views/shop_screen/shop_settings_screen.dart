import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/profile_controller.dart';
import 'package:e_community/controller/shop_controller.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/widgets_common/custom_textfield_for_shop.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ShopController>();
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
            ),
          ),
          title: boldText(text: shopSetting, size: 16.0),
          actions: [
            controller.isLoading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);
                      await controller.updateShop(
                        shopname: controller.shopNameConroller.text,
                        shopAddress: controller.shopAddressConroller.text,
                        shopmobil: controller.shopMobilConroller.text,
                        shopwebsite: controller.shopWebsiteConroller.text,
                        shopdesc: controller.shopDescConroller.text,
                        sellerpolicy: controller.sellerPolicyConroller.text,
                        returnpolicy: controller.returnPolicyConroller.text,
                        supportpolicy: controller.supportPolicyConroller.text,
                      );

                      await Get.find<ProfileController>()
                          .haveShop(currentUser!.uid);

                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Shop Updated");
                      Get.back();
                    },
                    child: normalText(
                      text: save,
                    ),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                customTextFieldForShop(
                  controller: controller.shopNameConroller,
                  label: shopName,
                  hint: nameHint,
                ),
                25.heightBox,
                customTextFieldForShop(
                    label: address,
                    hint: shopAddressHint,
                    controller: controller.shopAddressConroller),
                25.heightBox,
                customTextFieldForShop(
                    label: mobile,
                    hint: shopMobileHint,
                    controller: controller.shopMobilConroller),
                25.heightBox,
                customTextFieldForShop(
                    label: website,
                    hint: shopWebsiteHint,
                    controller: controller.shopWebsiteConroller),
                25.heightBox,
                customTextFieldForShop(
                    label: description,
                    hint: shopDescHint,
                    isDesc: true,
                    controller: controller.shopDescConroller),
                25.heightBox,
                customTextFieldForShop(
                    label: sellerPolicy,
                    hint: sellerPolicyHint,
                    isDesc: true,
                    controller: controller.sellerPolicyConroller),
                25.heightBox,
                customTextFieldForShop(
                    label: returnPolicy,
                    hint: returnPolicyHint,
                    isDesc: true,
                    controller: controller.returnPolicyConroller),
                25.heightBox,
                customTextFieldForShop(
                    label: supportPolicy,
                    hint: supportPolicyHint,
                    isDesc: true,
                    controller: controller.supportPolicyConroller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
