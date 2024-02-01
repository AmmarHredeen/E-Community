import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/text_style.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: purpleColor,
    automaticallyImplyLeading: false,
    title: boldText(text: title, color: white, size: 16.0),
    actions: [
      Center(
        child: boldText(
            text: intl.DateFormat("EEE, MMM d, ''yy").format(DateTime.now()),
            color: white),
      ),
      10.widthBox,
    ],
  );
}
