import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/text_style.dart';

Widget customTextFieldForShop({label, hint, controller, isDesc = false}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: white),
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
        isDense: true,
        label: normalText(text: label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: white),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )),
        hintText: hint,
        hintStyle: const TextStyle(color: fontGrey)),
  );
}
