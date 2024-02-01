import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUserName();
    super.onInit();
  }

  var currentNavIndex = 0.obs;

  var username = '';

  var featuredList = [];

  var searchController = TextEditingController();

  calculateRating(data) async {
    double total = 0.0;
    if (data['id_rating'].length != 0) {
      await data['id_rating'].forEach((key, value) {
        total += double.parse(value);
      });
      await firestore.collection(productsCollection).doc(data.id).set(
          {'p_rating': (total / data['id_rating'].length).toString()},
          SetOptions(merge: true));
    }
  }

  getUserName() async {
    var n = await firestore
        .collection(usersCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      } else {
        return "User";
      }
    });
    username = n;
  }
}
