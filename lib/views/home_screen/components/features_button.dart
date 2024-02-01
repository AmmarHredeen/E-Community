import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/product_controller.dart';
import 'package:e_community/views/category_screen/category_details.dart';
import 'package:get/get.dart';

Widget featurButton({String? title, icon}) {
  // ignore: unused_local_variable
  var controller = Get.put(ProductController());
  return Row(
    children: [
      Image.asset(
        icon,
        width: 60,
        fit: BoxFit.fill,
      ),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
      .box
      .width(200)
      .white
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
    Get.to(() => CategoryDetails(title: title));
  });
}
