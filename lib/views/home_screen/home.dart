import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/views/cart_screen/cart_screen.dart';
import 'package:e_community/views/category_screen/category_screen.dart';
import 'package:e_community/views/home_screen/home_screen.dart';
import 'package:e_community/views/profile_screen/profile_screen.dart';
import 'package:e_community/widgets_common/exit_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;

  var navBody = [
    const HomeScereen(),
    const CategoryScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          backgroundColor: _page == 2 ? white : lightGrey,
          color: redColor,
          animationDuration: const Duration(milliseconds: 400),
          items: [
            Image.asset(
              icHome,
              width: 26,
              color: white,
            ),
            Image.asset(
              icCategories,
              width: 26,
              color: white,
            ),
            Image.asset(
              icCart,
              width: 26,
              color: white,
            ),
            Image.asset(
              icProfile,
              width: 26,
              color: white,
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: navBody[_page],
      ),
    );
  }
}
