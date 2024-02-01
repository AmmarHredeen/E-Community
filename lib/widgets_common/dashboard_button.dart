import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/text_style.dart';

Widget dashboardButton(context, {title, count, icon}) {
  var size = MediaQuery.of(context).size;
  return Row(
    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText(text: title, size: 16.0)
                .box
                .padding(const EdgeInsets.symmetric(horizontal: 4))
                .make(),
            boldText(text: count, size: 20.0)
                .box
                .padding(const EdgeInsets.symmetric(horizontal: 8))
                .make(),
          ],
        ),
      ),
      Image.asset(
        icon,
        width: 40,
        color: white,
      )
    ],
  )
      .box
      .color(purpleColor)
      .size(size.width * 0.4, 80)
      .rounded
      .padding(const EdgeInsets.all(8.0))
      .make();
}
