import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/home_controller.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    getChateId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chateDocId;

  var isLoading = false.obs;

  getChateId() async {
    isLoading(true);
    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chateDocId = snapshot.docs.single.id;
          } else {
            chats.add({
              'created_on': null,
              'last_msg': '',
              'users': {friendId: null, currentId: null},
              'toid': '',
              'fromid': '',
              'friendname': friendName,
              'sendername': senderName
            }).then((value) {
              {
                chateDocId = value.id;
              }
            });
          }
        });
    isLoading(false);
  }

  sendMessage(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chateDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toid': friendId,
        'fromid': currentId,
      });
      chats.doc(chateDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }

  sendFirestMessage(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chateDocId).update({
        'firest_msg_from': currentId,
        'firest_msg_to': friendId,
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toid': friendId,
        'fromid': currentId,
      });
      chats.doc(chateDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
