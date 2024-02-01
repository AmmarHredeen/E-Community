import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_community/consts/consts.dart';
import 'package:e_community/controller/product_controller.dart';
import 'package:e_community/services/firestore_services.dart';
import 'package:e_community/views/category_screen/video_screen.dart';
import 'package:e_community/views/chat_screen/chat_screen.dart';
import 'package:e_community/widgets_common/loading_indicator.dart';
import 'package:e_community/widgets_common/our_butten.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ItemDetails extends StatefulWidget {
  String? title;
  String? cat;
  dynamic data;
  ItemDetails({super.key, required this.title, required this.cat, this.data});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.cat);
    // controller.calculateRating(widget.data);
  }

  switchCategory(cat) {
    if (controller.subcat.contains(cat)) {
      productMethod = FirestoreServices.getSubCategoryProducts(cat);
    } else {
      productMethod = FirestoreServices.getProducts(cat);
    }
  }

  var controller = Get.put(ProductController());

  dynamic productMethod;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: redColor,
          leading: IconButton(
              color: white,
              onPressed: () {
                controller.resetValue();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: widget.title!.text.fontFamily(bold).white.make(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
              color: white,
            ),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removFromWishlist(widget.data.id, context);
                    } else {
                      controller.addToWishlist(widget.data.id, context);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? green : white,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Swiper Sction
                    VxSwiper.builder(
                        itemCount: widget.data['p_image'].length,
                        height: 350,
                        autoPlay: true,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.data['p_image'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }),

                    //! Title and Details Sction
                    10.heightBox,
                    widget.title!.text
                        .color(darkFontGrey)
                        .fontFamily(bold)
                        .make(),

                    //! Rating
                    10.heightBox,
                    Row(
                      children: [
                        VxRating(
                          isSelectable: true,
                          value: double.parse(widget.data['p_rating']),
                          onRatingUpdate: (value) async {
                            if (widget.data['id_rating'][currentUser!.uid] ==
                                null) {
                              await controller.rating(
                                  widget.data, value.toString());
                              // ignore: use_build_context_synchronously
                              VxToast.show(context,
                                  msg: 'Your\'e rating  $value');
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: lightGolden,
                                        title: const Text(
                                          'Rating',
                                          style: TextStyle(
                                              color: redColor,
                                              fontFamily: bold),
                                        ),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "your rating for this product is ${widget.data['id_rating'][currentUser!.uid]}, "),
                                            10.heightBox,
                                            const Text(
                                              "Do you want to change ? ",
                                              style: TextStyle(color: redColor),
                                            ),
                                            20.heightBox,
                                            VxRating(
                                              isSelectable: true,
                                              value: double.parse(
                                                  widget.data['id_rating']
                                                      [currentUser!.uid]),
                                              onRatingUpdate: (value) async {
                                                await controller.rating(
                                                    widget.data,
                                                    value.toString());
                                                // ignore: use_build_context_synchronously
                                                VxToast.show(context,
                                                    msg:
                                                        'Your\'e rating  $value');
                                              },
                                              normalColor: textfieldGrey,
                                              selectionColor: golden,
                                              count: 5,
                                              maxRating: 5,
                                              size: 40,
                                            ),
                                          ],
                                        ).box.height(120).make(),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Save",
                                                style:
                                                    TextStyle(color: redColor),
                                              ))
                                        ],
                                      ));
                            }
                          },
                          normalColor: textfieldGrey,
                          selectionColor: golden,
                          count: 5,
                          maxRating: 5,
                          size: 30,
                        ),
                        10.widthBox,
                        "(${widget.data['id_rating'].length}  Review)"
                            .text
                            .color(golden)
                            .fontFamily(semibold)
                            .size(14)
                            .make(),
                      ],
                    ),
                    10.heightBox,
                    Column(
                      children: [
                        10.widthBox,
                        widget.data['is_deal'] == '0'
                            ? const SizedBox()
                            : Row(
                                children: [
                                  "${widget.data['p_price']}"
                                      .numCurrency
                                      .text
                                      .lineThrough
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(14)
                                      .make(),
                                  " \$"
                                      .text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(14)
                                      .make()
                                ],
                              ),
                        Row(
                          children: [
                            "${int.parse(widget.data['p_price']) - int.parse(widget.data['is_deal'])}"
                                .numCurrency
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(18)
                                .make(),
                            " \$"
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .size(18)
                                .make()
                          ],
                        ),
                      ],
                    ),
                    10.heightBox,
                    Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Seller".text.bold.make(),
                                5.heightBox,
                                "${widget.data['p_seller']}".text.bold.make()
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_rounded,
                              color: darkFontGrey,
                            ),
                          ).onTap(() {
                            Get.to(
                              () => const ChatScreen(),
                              arguments: [
                                widget.data['p_seller'],
                                widget.data['vendor_id'],
                                0
                              ],
                            );
                          }),
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .make(),
                    ),

                    //! Color Sction
                    20.heightBox,
                    Obx(
                      () => Card(
                          child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Color ".text.bold.make(),
                                ),
                                Row(
                                  children: List.generate(
                                      widget.data['p_colors'].length,
                                      (index) => Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              VxBox()
                                                  .size(40, 40)
                                                  .roundedFull
                                                  //.color(Vx.randomPrimaryColor)
                                                  .color(Color(widget
                                                              .data['p_colors']
                                                          [index])
                                                      .withOpacity(1.0))
                                                  .margin(const EdgeInsets
                                                      .symmetric(horizontal: 6))
                                                  .make()
                                                  .onTap(() {
                                                controller
                                                    .changeColorIndex(index);
                                              }),
                                              Visibility(
                                                visible: index ==
                                                    controller.colorIndex.value,
                                                child: Icon(
                                                  Icons.done,
                                                  color: widget.data['p_colors']
                                                              [index] ==
                                                          Colors.white.value
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              )
                                            ],
                                          )),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ),

                          //! Quantity Row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity ".text.bold.make(),
                              ),
                              Obx(() => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(
                                                    widget.data['p_price']));
                                            controller.calculateTotalDiscount(
                                                int.parse(
                                                    widget.data['is_deal']));
                                          },
                                          icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(
                                                    widget.data['p_quantity']));
                                            controller.calculateTotalPrice(
                                                int.parse(
                                                    widget.data['p_price']));
                                            controller.calculateTotalDiscount(
                                                int.parse(
                                                    widget.data['is_deal']));
                                          },
                                          icon: const Icon(Icons.add)),
                                      10.widthBox,
                                      "(${widget.data['p_quantity']} available)"
                                          .text
                                          .color(textfieldGrey)
                                          .make(),
                                    ],
                                  )),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Total Price".text.bold.make(),
                              ),
                              "${controller.totalPrice.value - controller.totalDiscount.value}"
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .size(16)
                                  .make(),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                        ],
                      )),
                    ),
                    10.heightBox,
                    "Description"
                        .text
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    10.heightBox,
                    "${widget.data['p_desc']}".text.color(darkFontGrey).make(),

                    //! Buttons Sction
                    10.heightBox,
                    StreamBuilder(
                      stream:
                          FirestoreServices.getPolicy(widget.data['vendor_id']),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else if (snapshot.data!.docs.isEmpty) {
                          return "No Policy for this product".text.make();
                        } else {
                          var policy = snapshot.data!.docs;
                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                                itemDeatailsButtonList.length,
                                (index) => ListTile(
                                      onTap: () {
                                        switch (index) {
                                          case 0:
                                            if (widget.data['p_video'] == '') {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        backgroundColor:
                                                            lightGolden,
                                                        title: const Text(
                                                          'Video',
                                                          style: TextStyle(
                                                              color: redColor,
                                                              fontFamily: bold),
                                                        ),
                                                        content: const Text(
                                                            'No video added for this product'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                "Close",
                                                                style: TextStyle(
                                                                    color:
                                                                        redColor),
                                                              ))
                                                        ],
                                                      ));
                                            } else {
                                              Get.to(() => Video(
                                                    videoLink:
                                                        widget.data['p_video'],
                                                  ));
                                            }

                                            break;
                                          case 1:
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      backgroundColor:
                                                          lightGolden,
                                                      title: Text(
                                                        itemDeatailsButtonList[
                                                            index],
                                                        style: const TextStyle(
                                                            color: redColor,
                                                            fontFamily: bold),
                                                      ),
                                                      content: Text(policy[0]
                                                          ['return_policy']),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              "Close",
                                                              style: TextStyle(
                                                                  color:
                                                                      redColor),
                                                            ))
                                                      ],
                                                    ));
                                            break;
                                          case 2:
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      backgroundColor:
                                                          lightGolden,
                                                      title: Text(
                                                        itemDeatailsButtonList[
                                                            index],
                                                        style: const TextStyle(
                                                            color: redColor,
                                                            fontFamily: bold),
                                                      ),
                                                      content: Text(policy[0]
                                                          ['support_policy']),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              "Close",
                                                              style: TextStyle(
                                                                  color:
                                                                      redColor),
                                                            ))
                                                      ],
                                                    ));
                                            break;
                                          case 3:
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      backgroundColor:
                                                          lightGolden,
                                                      title: Text(
                                                        itemDeatailsButtonList[
                                                            index],
                                                        style: const TextStyle(
                                                            color: redColor,
                                                            fontFamily: bold),
                                                      ),
                                                      content: Text(policy[0]
                                                          ['seller_policy']),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              "Close",
                                                              style: TextStyle(
                                                                  color:
                                                                      redColor),
                                                            ))
                                                      ],
                                                    ));
                                            break;
                                        }
                                      },
                                      title: itemDeatailsButtonList[index]
                                          .text
                                          .color(darkFontGrey)
                                          .fontFamily(semibold)
                                          .make(),
                                      trailing: const Icon(Icons.arrow_forward),
                                    )),
                          );
                        }
                      },
                    ),

                    //! product may like sction
                    20.heightBox,
                    productSyoumayLike.text
                        .fontFamily(bold)
                        .size(16)
                        .color(darkFontGrey)
                        .make(),
                    10.heightBox,
                    StreamBuilder(
                      stream: productMethod,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else if (snapshot.data!.docs.isEmpty) {
                          return "No products found !"
                              .text
                              .color(darkFontGrey)
                              .make();
                        } else {
                          var x = snapshot.data!.docs;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  x.length,
                                  (index) => Card(
                                        color: lightGolden,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              x[index]['p_image'][0],
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                            10.heightBox,
                                            "${x[index]['p_name']}"
                                                .text
                                                .fontFamily(semibold)
                                                .color(darkFontGrey)
                                                .make(),
                                            10.heightBox,
                                            x[index]['is_deal'] == '0'
                                                ? const SizedBox()
                                                : Row(
                                                    children: [
                                                      "${x[index]['p_price']}"
                                                          .numCurrency
                                                          .text
                                                          .lineThrough
                                                          .color(redColor)
                                                          .fontFamily(bold)
                                                          .size(14)
                                                          .make(),
                                                      " \$"
                                                          .text
                                                          .color(redColor)
                                                          .fontFamily(bold)
                                                          .size(14)
                                                          .make()
                                                    ],
                                                  ),
                                            Row(
                                              children: [
                                                "${int.parse(x[index]['p_price']) - int.parse(x[index]['is_deal'])}"
                                                    .numCurrency
                                                    .text
                                                    .color(redColor)
                                                    .fontFamily(bold)
                                                    .size(16)
                                                    .make(),
                                                " \$"
                                                    .text
                                                    .color(redColor)
                                                    .fontFamily(bold)
                                                    .size(16)
                                                    .make()
                                              ],
                                            ),
                                          ],
                                        )
                                            .box
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 4))
                                            .roundedSM
                                            .padding(const EdgeInsets.all(8))
                                            .make()
                                            .onTap(() {
                                          setState(() {
                                            widget.data = x[index];
                                            widget.cat =
                                                x[index]['p_subcategory'];
                                            widget.title = x[index]['p_name'];
                                          });
                                        }),
                                      )),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            )),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 60,
                child: ourButten(
                  color: controller.quantity.value > 0 ? redColor : lightGolden,
                  title: "Add TO Cart",
                  textColor:
                      controller.quantity.value > 0 ? white : darkFontGrey,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                          context: context,
                          color: widget.data['p_colors']
                              [controller.colorIndex.value],
                          vendorID: widget.data['vendor_id'],
                          img: widget.data['p_image'][0],
                          qty: controller.quantity.value,
                          sellername: widget.data['p_seller'],
                          title: widget.data['p_name'],
                          discount: widget.data['is_deal'],
                          tprice: (controller.totalPrice.value -
                              controller.totalDiscount.value));

                      VxToast.show(context, msg: "Added to Cart");
                    } else {
                      VxToast.show(context, msg: "Quantity can not be 0");
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
