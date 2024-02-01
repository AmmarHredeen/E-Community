import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:flutter/services.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
        const Divider(),
        10.heightBox,
        "Are you sure you want to exit ? "
            .text
            .size(16)
            .color(darkFontGrey)
            .make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButten(
                color: redColor,
                onPress: () {
                  SystemNavigator.pop();
                },
                textColor: white,
                title: "Yes"),
            ourButten(
                color: redColor,
                onPress: () {
                  Navigator.pop(context);
                },
                textColor: white,
                title: "No"),
          ],
        ),
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
