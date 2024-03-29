import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ShopController extends GetxController {
  var profileImgPath = ''.obs;
  var profileImgLink = '';
  var isLoading = false.obs;

  //! textfild
  var nameConroller = TextEditingController();
  var oldpassConroller = TextEditingController();
  var newpassConroller = TextEditingController();

  //! Shop Controller
  var shopNameConroller = TextEditingController();
  var shopAddressConroller = TextEditingController();
  var shopMobilConroller = TextEditingController();
  var shopWebsiteConroller = TextEditingController();
  var shopDescConroller = TextEditingController();
  var sellerPolicyConroller = TextEditingController();
  var returnPolicyConroller = TextEditingController();
  var supportPolicyConroller = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImgLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set(
        {'vendor_name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isLoading(false);
  }

  changeAuthPassword({email, password, newPassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newPassword);
    }).catchError((error) {
      // ignore: avoid_print
      print(error.toString());
    });
  }

  updateShop(
      {shopname,
      shopAddress,
      shopmobil,
      shopwebsite,
      shopdesc,
      sellerpolicy,
      returnpolicy,
      supportpolicy}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({
      'id': currentUser!.uid,
      'shop_name': shopname,
      'shop_address': shopAddress,
      'shop_mobile': shopmobil,
      'shop_website': shopwebsite,
      'shop_desc': shopdesc,
      'seller_policy': sellerpolicy,
      'return_policy': returnpolicy,
      'support_policy': supportpolicy
    }, SetOptions(merge: true));
    isLoading(false);
  }
}
