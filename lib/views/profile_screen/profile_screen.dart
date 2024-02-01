import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/auth_controller.dart';
import 'package:e_community/controller/profile_controller.dart';
import 'package:e_community/controller/shop_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/auth_screen/login_screen.dart';
import 'package:e_community/views/chat_screen/messaging_screen.dart';
import 'package:e_community/views/orders_screen/orders_screen.dart';
import 'package:e_community/views/profile_screen/components/details_card.dart';
import 'package:e_community/views/profile_screen/edit_profile_screen.dart';
import 'package:e_community/views/shop_screen/home_shop_screen.dart';
import 'package:e_community/views/shop_screen/shop_settings_screen.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/views/wishlist_screen/wishlist_screen.dart';
import 'package:e_community/widgets_common/bg_widget.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    // ignore: unused_local_variable
    var controller1 = Get.put(ShopController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    //! Edit Profile Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.edit,
                          color: white,
                        ),
                      ).onTap(() {
                        controller.nameConroller.text = data['name'];
                        Get.to(() => EditProfileScreen(
                              data: data,
                            ));
                      }),
                    ),
                    //! User Details Sction
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: white,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(data['imageUrl'],
                                      width: 75, fit: BoxFit.cover)
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .white
                                    .fontFamily(semibold)
                                    .make(),
                                5.heightBox,
                                "${data['email']}".text.white.make(),
                              ],
                            ),
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: white),
                              ),
                              onPressed: () async {
                                await Get.put(AuthController())
                                    .signoutMethod(context);
                                Get.offAll(() => const LoginScreen());
                              },
                              child: "Log out"
                                  .text
                                  .white
                                  .fontFamily(semibold)
                                  .make()),
                        ],
                      ),
                    ),
                    20.heightBox,
                    FutureBuilder(
                        future: FirestoreServices.getCount(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: loadingIndicator(circleColor: redColor));
                          } else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                detailsCaed(
                                    count: countData[0].toString(),
                                    title: "in your cart",
                                    width: context.screenWidth / 3.3),
                                detailsCaed(
                                    count: countData[1].toString(),
                                    title: "in your wishlist",
                                    width: context.screenWidth / 3.3),
                                detailsCaed(
                                    count: countData[2].toString(),
                                    title: "your orders",
                                    width: context.screenWidth / 3.3),
                              ],
                            );
                          }
                        }),

                    20.heightBox,

                    ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  data['is_vendor'] == true
                                      ? Get.to(() => const HomeShopScreen())
                                      : Get.to(() => const ShopSettings());
                                },
                                leading: Image.asset(
                                  icAccount,
                                  width: 22,
                                  color: darkFontGrey,
                                ),
                                title: data['is_vendor'] == true
                                    ? myShop.text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make()
                                    : createShop.text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                trailing: const Icon(
                                  Icons.arrow_circle_right,
                                  color: red,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: lightGrey,
                              );
                            },
                            itemCount: 1)
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .shadowSm
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                    ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => const OrdersScreen());
                                      break;
                                    case 1:
                                      Get.to(() => const WishlistScreen());
                                      break;
                                    case 2:
                                      Get.to(() => const MessagesScreen());
                                      break;
                                    // case 3:
                                    //   Get.to(() => const HomeShopScreen());
                                    //   break;
                                  }
                                },
                                leading: Image.asset(
                                  profileButtonsIcon[index],
                                  width: 22,
                                  color: darkFontGrey,
                                ),
                                title: profileButtonsList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                trailing: const Icon(
                                  Icons.arrow_circle_right,
                                  color: red,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: lightGrey,
                              );
                            },
                            itemCount: profileButtonsList.length)
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .shadowSm
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
