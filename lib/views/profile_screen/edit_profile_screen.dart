import 'dart:io';
import 'package:e_community/controller/profile_controller.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:e_community/widgets_common/bg_widget.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/custom_textfield.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: boldText(text: editProfile, color: white, size: 16.0),
          leading: const Icon(
            Icons.arrow_back,
            color: white,
          ).onTap(() {
            Get.back();
          }),
        ),
        body: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* if data image url and controller path is empty
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: redColor,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  //* if data image url is not empty but controller path is empty
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      //* if controller path is not empty but image url is empty
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ourButten(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: white,
                  title: "Change"),
              const Divider(),
              20.heightBox,
              customTextField(
                  controller: controller.nameConroller,
                  hint: nameHint,
                  title: name,
                  isPass: false),
              10.heightBox,
              customTextField(
                  controller: controller.oldpassConroller,
                  hint: passwordHint,
                  title: oldpass,
                  isPass: true),
              10.heightBox,
              customTextField(
                  controller: controller.newpassConroller,
                  hint: passwordHint,
                  title: newpass,
                  isPass: true),
              20.heightBox,
              controller.isLoading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButten(
                          color: redColor,
                          onPress: () async {
                            controller.isLoading(true);
                            //* if image is not slected
                            if (controller.profileImgPath.value.isNotEmpty) {
                              await controller.uploadProfileImage();
                            } else {
                              controller.profileImgLink = data['imageUrl'];
                            }

                            //* if old password matches database
                            if (data['password'] ==
                                controller.oldpassConroller) {
                              await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassConroller.text,
                                newPassword: controller.newpassConroller.text,
                              );
                              await controller.uploadProfileImage();
                              await controller.updateProfile(
                                  imgUrl: controller.profileImgLink,
                                  name: controller.nameConroller.text,
                                  password: controller.newpassConroller.text);
                              // ignore: use_build_context_synchronously
                              VxToast.show(context, msg: "Updated");
                            } else {
                              // ignore: use_build_context_synchronously
                              VxToast.show(context, msg: "Wrong old password");
                              controller.isLoading(false);
                            }
                          },
                          textColor: white,
                          title: "Save"),
                    ),
            ],
          )
              .box
              .shadowSm
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
              .rounded
              .white
              .make(),
        ),
      ),
    );
  }
}
