import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/home_controller.dart';
import 'package:e_community/models/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var totalDiscount = 0.obs;

  var subcat = [];

  var isFav = false.obs;
  var isloading = false.obs;

  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var dealController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var pVideoLink = '';
  var filePath = '';

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = [
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
    Colors.amber.value,
  ];

  getSubCategory(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  calculateTotalDiscount(discount) {
    totalDiscount.value = discount * quantity.value;
  }

  addToCart(
      {title,
      img,
      sellername,
      color,
      qty,
      tprice,
      context,
      vendorID,
      discount}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'vendor_id': vendorID,
      'qty': qty,
      'tprice': tprice,
      'added_by': currentUser!.uid,
      'discount': discount
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValue() {
    totalPrice.value = 0;
    totalDiscount.value = 0;
    colorIndex.value = 0;
    quantity.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added Favorite");
  }

  removFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed Favorite");
  }

  checkIfFav(data) {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }

  getCategories() async {
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategoryList(cat) {
    subcategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  Future<void> pickVideo() async {
    filePath = '';
    // Pick the video from the gallery
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get the file path
      filePath = pickedFile.path;
    }
  }

  uploadVideo() async {
    pVideoLink = '';
    // Upload the video to Firebase Storage
    try {
      final reference = FirebaseStorage.instance
          .ref('/videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
      final uploadTask = reference.putFile(File(filePath));
      await uploadTask.whenComplete(() async {
        pVideoLink = await reference.getDownloadURL();
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  uploadProduct(context) async {
    var x = [];
    for (var element in selectedColorIndex) {
      if (element != Colors.amber.value) {
        x.add(element);
      }
    }
    Map<String, dynamic> details = {};
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'id_rating': details,
      'is_featured': false,
      'is_deal': '0',
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion(x),
      'p_image': FieldValue.arrayUnion(pImagesLinks),
      'p_video': pVideoLink,
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_name': pnameController.text,
      'p_desc': pdescController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "0.0",
      'vendor_id': currentUser!.uid,
      'featured_id': ''
    });
    for (var i = 0; i < selectedColorIndex.length; i++) {
      selectedColorIndex[i] = Colors.amber.value;
    }
    pVideoLink = '';

    isloading(false);

    VxToast.show(context, msg: "Product Uploaded Successfully");
  }

  editProduct(context, docId) async {
    var x = [];
    for (var element in selectedColorIndex) {
      if (element != Colors.amber.value) {
        x.add(element);
      }
    }
    await firestore.collection(productsCollection).doc(docId).set({
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion(x),
      'p_name': pnameController.text,
      'p_desc': pdescController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
    }, SetOptions(merge: true));
    for (var i = 0; i < selectedColorIndex.length; i++) {
      selectedColorIndex[i] = Colors.amber.value;
    }
    isloading(false);
    VxToast.show(context, msg: "Product Updated Successfully");
  }

  rating(data, count) async {
    await firestore.collection(productsCollection).doc(data.id).set({
      'id_rating': {currentUser!.uid.toString(): count}
    }, SetOptions(merge: true));
  }

  addFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    firestore.collection(productsCollection).doc(docId).delete();
  }

  addDeal(docId, count) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'is_deal': count,
    }, SetOptions(merge: true));
  }

  removeDeal(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'is_deal': '0',
    }, SetOptions(merge: true));
  }
}
