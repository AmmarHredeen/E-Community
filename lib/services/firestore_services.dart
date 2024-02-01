// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';

class FirestoreServices {
  //! Get user dataS
  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //! Get Policy
  static getPolicy(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //! Get product according to category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  //! Get product according to subcategory
  static getSubCategoryProducts(subcategory) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: subcategory)
        .snapshots();
  }

  //! Get deal products
  static getDealProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_deal', isNotEqualTo: '0')
        .snapshots();
  }

  //! Get Cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  //! Delete document
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  //! Get all chats messages
  static getChatMessage(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  //! Get all orders
  static getAllOreders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  //! Get all wishlist
  static getAllWishlist() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  //! Get all messages
  static getMessagesFromMe() {
    return firestore
        .collection(chatsCollection)
        .where('firest_msg_from', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getMessagesToMe() {
    return firestore
        .collection(chatsCollection)
        .where('firest_msg_to', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCount() async {
    var res = await Future.wait(
      [
        firestore
            .collection(cartCollection)
            .where('added_by', isEqualTo: currentUser!.uid)
            .get()
            .then((value) {
          return value.docs.length;
        }),
        firestore
            .collection(productsCollection)
            .where('p_wishlist', arrayContains: currentUser!.uid)
            .get()
            .then((value) {
          return value.docs.length;
        }),
        firestore
            .collection(ordersCollection)
            .where('order_by', isEqualTo: currentUser!.uid)
            .get()
            .then((value) {
          return value.docs.length;
        })
      ],
    );
    return res;
  }

  static allProducts() {
    return firestore
        .collection(productsCollection)
        // .where('vendor_id', isNotEqualTo: currentUser!.uid)
        .snapshots();
  }

  //! Get Featured products Method
  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  // static getFeaturedProducts() async {
  //   CollectionReference product =
  //       FirebaseFirestore.instance.collection(productsCollection);
  //   QuerySnapshot querySnapshot = await product
  //       .where('is_featured', isEqualTo: true)
  //       // .where('age', isGreaterThan: 30)
  //       .where('vendor_id', isNotEqualTo: currentUser!.uid)
  //       .get();
  // }

  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  static getShop() {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get();
  }

  static getOrdersShop() {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getProductShop() {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: currentUser!.uid)
        .snapshots();
  }
}
