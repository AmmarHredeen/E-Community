import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/chats_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/chat_screen/components/sender_bubble.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    var isFirstMsg = false;
    var pColor = Get.arguments[2] == 0 ? redColor : purpleColor;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: pColor,
        title:
            "${controller.friendName}".text.fontFamily(semibold).white.make(),
        leading: const Icon(Icons.arrow_back, color: white).onTap(() {
          Get.back();
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(circleColor: pColor),
                    )
                  : Expanded(
                      child: StreamBuilder(
                          stream: FirestoreServices.getChatMessage(
                              controller.chateDocId.toString()),
                          builder: (BuildContext contextn,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(circleColor: pColor),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              isFirstMsg = true;
                              return Center(
                                child: "Send a message..."
                                    .text
                                    .color(darkFontGrey)
                                    .make(),
                              );
                            } else {
                              try {
                                return ListView(
                                  children: snapshot.data!.docs
                                      .mapIndexed((currentValue, index) {
                                    var data = snapshot.data!.docs[index];
                                    return Align(
                                        alignment:
                                            data['uid'] == currentUser!.uid
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: senderBubble(data, pColor));
                                  }).toList(),
                                );
                              } catch (e) {
                                VxToast.show(context, msg: e.toString());
                              }
                              return ''.text.make();
                            }
                          })),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  cursorHeight: 20,
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        )),
                    hintText: "Type a message...",
                  ),
                )),
                IconButton(
                        onPressed: () {
                          isFirstMsg == true
                              ? controller.sendFirestMessage(
                                  controller.msgController.text)
                              : controller
                                  .sendMessage(controller.msgController.text);
                          controller.msgController.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: pColor,
                        ))
                    .box
                    // .height(60)
                    // .margin(const EdgeInsets.only(bottom: 2))
                    .padding(const EdgeInsets.all(4))
                    .make(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
