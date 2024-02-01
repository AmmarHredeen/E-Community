import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/cart_controller.dart';
import 'package:e_community/views/home_screen/home.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: white,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(circleColor: redColor),
                )
              : ourButten(
                  onPress: () async {
                    await controller.placeMyOrder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.totalprice.value);
                    await controller.clearCart();
                    // ignore: use_build_context_synchronously
                    VxToast.show(context, msg: "Order placed successfully");
                    Get.to(const Home());
                  },
                  color: redColor,
                  textColor: white,
                  title: "Place my order  "),
        ),
        appBar: AppBar(
          backgroundColor: redColor,
          title: "Chose Payment Method".text.fontFamily(semibold).white.make(),
          leading: const Icon(
            Icons.arrow_back,
            color: white,
          ).onTap(() {
            Get.back();
          }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
                children: List.generate(paymentMethodsImg.length, (index) {
              return GestureDetector(
                onTap: () {
                  controller.changePaymntIndex(index);
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.paymentIndex.value == index
                            ? redColor
                            : Colors.transparent,
                        width: 4,
                      )),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(
                        paymentMethodsImg[index],
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        colorBlendMode: controller.paymentIndex.value == index
                            ? BlendMode.darken
                            : BlendMode.color,
                        color: controller.paymentIndex.value == index
                            ? Colors.black.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                      controller.paymentIndex.value == index
                          ? Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                activeColor: Colors.green,
                                value: true,
                                onChanged: (value) {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: paymentMethods[index]
                            .text
                            .white
                            .size(16)
                            .fontFamily(semibold)
                            .make(),
                      ),
                    ],
                  ),
                ),
              );
            })),
          ),
        ),
      ),
    );
  }
}
