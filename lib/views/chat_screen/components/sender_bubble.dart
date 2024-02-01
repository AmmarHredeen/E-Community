import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

Widget senderBubble(DocumentSnapshot data, Color pColor) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);

  return Directionality(
    textDirection:
        data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: data['uid'] == currentUser!.uid ? pColor : darkFontGrey,
          borderRadius: data['uid'] == currentUser!.uid
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.white.size(16).make(),
          time.text.color(white.withOpacity(0.5)).make(),
        ],
      ),
    ),
  );
}
