import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/product_controller.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:get/get.dart';

Widget productDropdown(
    hint, List<String> list, dropvalue, ProductController controller) {
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: normalText(text: "$hint", color: fontGrey),
        value: dropvalue.value == '' ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(
            value: e,
            child: e.toString().text.make(),
          );
        }).toList(),
        onChanged: (newValue) {
          if (hint == "Category") {
            controller.subcategoryvalue.value = '';
            controller.populateSubcategoryList(newValue.toString());
          }
          dropvalue.value = newValue.toString();
        },
      ),
    )
        .box
        .white
        .padding(const EdgeInsets.symmetric(horizontal: 4))
        .roundedSM
        .make(),
  );
}
