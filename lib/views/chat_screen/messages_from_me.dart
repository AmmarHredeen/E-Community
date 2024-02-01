import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/chat_screen/chat_screen.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class MessagesFromMe extends StatelessWidget {
  const MessagesFromMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redColor,
        title: "Messages from me".text.color(white).fontFamily(semibold).make(),
        leading: const Icon(
          Icons.arrow_back,
          color: white,
        ).onTap(() {
          Get.back();
        }),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getMessagesFromMe(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No Messages Yet!".text.color(redColor).makeCentered();
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: [
                                    data[index]['friendname'],
                                    data[index]['firest_msg_to'],
                                    0
                                  ],
                                );
                              },
                              leading: const CircleAvatar(
                                backgroundColor: redColor,
                                child: Icon(
                                  Icons.person,
                                  color: white,
                                ),
                              ),
                              title: '${data[index]['friendname']}'
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              subtitle:
                                  '${data[index]['last_msg']}'.text.make(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
