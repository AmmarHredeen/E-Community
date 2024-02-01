import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/auth_controller.dart';
import 'package:e_community/views/auth_screen/login_screen.dart';
import 'package:e_community/widgets_common/applogo_widget.dart';
import 'package:e_community/widgets_common/bg_widget.dart';
import 'package:e_community/widgets_common/custom_textfield.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //! Text Controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            appLogoWidget(),
            10.heightBox,
            "Join the $appname ".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextField(
                    hint: nameHint,
                    title: name,
                    controller: nameController,
                    isPass: false,
                  ),
                  customTextField(
                    hint: emailHint,
                    title: email,
                    controller: emailController,
                    isPass: false,
                  ),
                  customTextField(
                    hint: passwordHint,
                    title: password,
                    controller: passwordController,
                    isPass: true,
                  ),
                  customTextField(
                    hint: passwordHint,
                    title: retypepassword,
                    controller: passwordRetypeController,
                    isPass: true,
                  ),
                  10.heightBox,
                  Row(
                    children: [
                      Checkbox(
                        value: isCheck,
                        activeColor: redColor,
                        checkColor: white,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                    fontFamily: regular, color: fontGrey),
                              ),
                              TextSpan(
                                text: termAndCond,
                                style: TextStyle(
                                    fontFamily: regular, color: redColor),
                              ),
                              TextSpan(
                                text: " & ",
                                style: TextStyle(
                                    fontFamily: regular, color: fontGrey),
                              ),
                              TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                    fontFamily: regular, color: redColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  5.heightBox,
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButten(
                          color: isCheck == true ? redColor : lightGrey,
                          textColor: white,
                          title: signup,
                          onPress: () async {
                            if (isCheck != false) {
                              controller.isloading(true);
                              try {
                                await controller
                                    .signupMethod(
                                        context: context,
                                        email: emailController.text,
                                        password: passwordController.text)
                                    .then((value) {
                                  return controller.storeUserData(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text);
                                }).then((value) {
                                  Get.offAll(() => const LoginScreen());
                                  VxToast.show(context,
                                      msg: "you nedd to verify your email");
                                });
                              } catch (e) {
                                auth.signOut();
                                // ignore: use_build_context_synchronously
                                VxToast.show(context, msg: e.toString());
                                controller.isloading(false);
                              }
                            }
                          },
                        ).box.width(context.screenWidth - 50).make(),
                  5.heightBox,
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: alreadyHaveAccount,
                          style: TextStyle(
                            fontFamily: regular,
                            color: fontGrey,
                          ),
                        ),
                        TextSpan(
                          text: login,
                          style: TextStyle(fontFamily: bold, color: redColor),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    Get.back();
                  })
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
