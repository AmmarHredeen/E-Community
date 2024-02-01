import 'package:e_community/consts/consts.dart';
import 'package:e_community/views/auth_screen/login_screen.dart';
import 'package:e_community/views/home_screen/home.dart';
import 'package:e_community/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
// method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //using getx

      auth.authStateChanges().listen((User? user) {
        if (user != null && currentUser!.emailVerified) {
          Get.to(() => const Home());
        } else {
          Get.to(() => const LoginScreen());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image.asset(icSplashBg, width: 300)),
            20.heightBox,
            appLogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox
          ],
        ),
      ),
    );
  }
}
