import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/views/chat_screen/messages_from_me.dart';
import 'package:e_community/views/chat_screen/messages_to_me.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _page = 0;

  var navBody = [
    const MessagesFromMe(),
    const MessagesToMe(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: white,
        color: _page == 0 ? redColor : purpleColor,
        animationDuration: const Duration(milliseconds: 400),
        items: [
          Image.asset(
            icMessages,
            width: 26,
            color: white,
          ),
          Image.asset(
            icMessages,
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
    );
  }
}
