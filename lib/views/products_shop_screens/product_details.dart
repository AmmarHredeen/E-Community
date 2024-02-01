import 'package:e_community/consts/consts.dart';
import 'package:e_community/widgets_common/text_style.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: purpleColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            )),
        title: boldText(text: "${data['p_name']}", color: white, size: 16.0),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VxSwiper.builder(
              itemCount: data['p_image'].length,
              height: 350,
              autoPlay: true,
              itemBuilder: (context, index) {
                return Image.network(
                  data['p_image'][index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }),

          //! Title and Details Sction
          10.heightBox,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(
                    text: "${data['p_name']}", color: fontGrey, size: 16.0),

                //! Category
                10.heightBox,
                Row(
                  children: [
                    boldText(
                        text: "${data['p_category']}",
                        color: fontGrey,
                        size: 16.0),
                    10.widthBox,
                    normalText(
                        text: "${data['p_subcategory']}",
                        color: fontGrey,
                        size: 16.0),
                  ],
                ),
                //! Rating
                10.heightBox,
                VxRating(
                  isSelectable: false,
                  value: double.parse(data['p_rating']),
                  onRatingUpdate: (value) {},
                  normalColor: textfieldGrey,
                  selectionColor: golden,
                  count: 5,
                  maxRating: 5,
                  size: 25,
                ),
                10.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(
                        text: data['is_featured'] == true ? "Featured" : '',
                        color: green),
                    20.widthBox,
                    data['is_deal'] == '0'
                        ? const SizedBox()
                        : Row(
                            children: [
                              "${data['p_price']}"
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
                                  .make(),
                              10.widthBox,
                              "Deal (${data['is_deal']})"
                                  .text
                                  .color(Colors.purple)
                                  .fontFamily(bold)
                                  .size(14)
                                  .make(),
                            ],
                          ),
                    Row(
                      children: [
                        "${int.parse(data['p_price']) - int.parse(data['is_deal'])}"
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
                            .make(),
                      ],
                    ),
                  ],
                ),
                20.heightBox,
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: boldText(text: "Color", color: white),
                            // child: "Color ".text.color(textfieldGrey).make(),
                          ),
                          Row(
                            children: List.generate(
                              data['p_colors'].length,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Color(data['p_colors'][index]))
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 6))
                                  .make()
                                  .onTap(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,

                    //! Quantity Row
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: boldText(text: "Quantity", color: white),
                        ),
                        normalText(
                            text: "${data['p_quantity']} itams", color: white),
                      ],
                    ),
                  ],
                )
                    .box
                    .color(purpleColor)
                    .roundedSM
                    .padding(const EdgeInsets.all(12.0))
                    .shadowSm
                    .make(),
                const Divider(color: white),
                10.heightBox,
                boldText(text: "Description", color: fontGrey),
                10.heightBox,
                normalText(text: "${data['p_desc']}", color: fontGrey)
              ],
            ),
          ),
        ],
      )),
    );
  }
}
