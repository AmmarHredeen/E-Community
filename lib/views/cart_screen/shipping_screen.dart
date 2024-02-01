import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/cart_controller.dart';
import 'package:e_community/views/cart_screen/payment_method.dart';
import 'package:e_community/widgets_common/custom_textfield.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redColor,
        title: "Shipping Info".text.fontFamily(semibold).white.make(),
        leading: const Icon(
          Icons.arrow_back,
          color: white,
        ).onTap(() {
          Get.back();
        }),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButten(
            onPress: () {
              if (controller.addressController.text.isNotEmptyAndNotNull &&
                  controller.cityController.text.isNotEmptyAndNotNull &&
                  controller.phoneController.text.isNotEmptyAndNotNull &&
                  controller.postalcodeController.text.isNotEmptyAndNotNull &&
                  controller.stateController.text.isNotEmptyAndNotNull) {
                Get.to(const PaymentMethods());
              } else {
                VxToast.show(context, msg: "Please fill the form");
              }
            },
            color: redColor,
            textColor: white,
            title: "Continue"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: "Address",
                title: "Address",
                isPass: false,
                controller: controller.addressController),
            customTextField(
                hint: "City",
                title: "City",
                isPass: false,
                controller: controller.cityController),
            customTextField(
                hint: "State",
                title: "State",
                isPass: false,
                controller: controller.stateController),
            customTextField(
                hint: "Postal Code",
                title: "Postal Code",
                isPass: false,
                controller: controller.postalcodeController),
            customTextField(
                hint: "Phone",
                title: "Phone",
                isPass: false,
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
