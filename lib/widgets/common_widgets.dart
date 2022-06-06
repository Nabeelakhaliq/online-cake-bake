import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_cake_ordering/models/new_product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';

AppBar customAppBar(String appBarTitle) {
  return AppBar(
    centerTitle: true,
    backgroundColor: AppColors.kAccentColor,
    title: Text(
      appBarTitle,
    ),
  );
}

Widget buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        // Text(
        //   food.description,
        //   maxLines: 2,
        //   overflow: TextOverflow.ellipsis,
        //   style: infoStyle,
        // ),
      ],
    ),
  );
}

Widget buildRating() {
  return Padding(
    padding: const EdgeInsets.only(left: 4, right: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RatingBar(
          initialRating: 5.0,
          direction: Axis.horizontal,
          itemCount: 5,
          itemSize: 14,
          unratedColor: Colors.black,
          itemPadding: const EdgeInsets.only(right: 4.0),
          ignoreGestures: true,
          itemBuilder: (context, index) => const Icon(Icons.star, color: AppColors.kAccentColor),
          onRatingUpdate: (rating) {},
        ),
        const Text('(10)'),
      ],
    ),
  );
}

Widget searchField(TextEditingController textEditingController, String hint, bool value) {
  return TextField(
    style: const TextStyle(color: AppColors.blackColor),
    controller: textEditingController,
    cursorColor: AppColors.blackColor,
    textAlign: TextAlign.start,
    // cursorRadius: Radius.circular(16.0),
    // cursorWidth: 5.0,
    textInputAction: TextInputAction.done,
    autofocus: false,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintStyle: TextStyle(
        color: AppColors.blackColor.withOpacity(0.5),
        fontSize: 13.0,
        fontWeight: FontWeight.w300,
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.only(bottom: 10, top: 10),
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      // suffixIcon: hint == 'Enter email' ? Icon(Icons.email,color: AppColors.black[100],) :Icon(Icons.lock,color: AppColors.black[100],),
    ),
  );
}

Widget myHorizontalDivider(){
  return const Divider(
    color: AppColors.smokeWhiteColor,
    thickness: 5,
    height: 5.0,
    indent: 0,
    endIndent: 0,
  );
}

Widget horizontalDivider(){
  return Divider(
    color: AppColors.blackColor.withOpacity(0.5),
    thickness: 1,
    height: 1.0,
    indent: 5,
    endIndent: 5,
  );
}

Widget myVerticalDivider(){
  return const VerticalDivider(
    color: AppColors.smokeWhiteColor,
    thickness: 5,
    width: 5.0,
    indent: 0,
    endIndent: 0,
  );
}

Widget iconTextWidget(IconData icon, String text){
  return Container(
    color: Colors.transparent,
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24.0,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Flexible(
          child: Container(
              child: customTextWidget(text, 12.0, AppColors.blackColor, FontWeight.bold)),

        )
      ],
    ),
  );
}

Widget buildPriceInfo(NewProductModel productModel, double price, VoidCallback onPress) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Rs. $price',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: const EdgeInsets.only(right: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(4),
          ),
          color: AppColors.kAccentColor,
          child: InkWell(
            onTap: onPress,
            splashColor: Colors.white70,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(4),
            ),
            child: const Icon(Icons.add, color: AppColors.whiteColor,),
          ),
        )
      ],
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(AppColors.kAccentColor),
    ),
  );
}

Widget customTextWidget(String text, double fontSize, Color textColor, FontWeight fontWeight) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    maxLines: 1,
    softWrap: true,
    style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Widget textWidget(String text, double fontSize, Color textColor, FontWeight fontWeight) {
  return Text(
    text,
    overflow: TextOverflow.fade,
    softWrap: true,
    style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Widget itemsListWidget(String imageUrl, String titleText, String shortDesc, double newPrice, double oldPrice) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      boxShadow: [
        // BoxShadow(
        //   color: AppColors.kDarkGreyColor.withOpacity(0.3),
        //   spreadRadius: 0.5,
        //   blurRadius: 1,
        //   offset: Offset(0, 0),
        // ),
        BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
      ],
      border: Border.all(width: 1, color:AppColors.blackColor.withOpacity(0.1)),
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              height: double.infinity,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0)
                  ),
                  child: Image.network(imageUrl, fit: BoxFit.fill))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(titleText != "" ? titleText : "", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.blackColor)),
                  shortDesc != ""
                      ? Text(shortDesc, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.blackColor))
                      : Container(),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      oldPrice != 0
                          ? Text(
                          "Rs. $oldPrice",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12.0,
                              color: Colors.black12
                          )
                      )
                          : Container(),
                      oldPrice != 0
                          ? const SizedBox(width: 5.0)
                          : Container(),
                      myTextWidget(
                          getDiscountPercentage(oldPrice, newPrice) != 0
                              ? "$newPrice (${getDiscountPercentage(oldPrice, newPrice)}%)"
                              : "$newPrice",
                          const TextStyle(fontSize: 12.0, color: AppColors.kAccentColor, fontWeight: FontWeight.bold),
                          1
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 5.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                  //         child: Text(oldPrice != "" ? oldPrice : "", textAlign: TextAlign.right, style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12.0, color: AppColors.unselectedColor, fontWeight: FontWeight.bold)),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                  //         child: Text(newPrice != "" ? newPrice : "", textAlign: TextAlign.left, style: TextStyle(fontSize: 12.0, color: AppColors.kPrimaryColor, fontWeight: FontWeight.bold)),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget itemsGridWidget(String imageUrl, String titleText, double newPrice, double oldPrice) {
  return Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(width: 1,color:AppColors.blackColor.withOpacity(0.1)),
      boxShadow: [
        BoxShadow(color: AppColors.whiteColor.withOpacity(0.5),),
      ],
    ),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.contain)),
                )
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: alignedTextWidget(titleText, const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: AppColors.blackColor), 2, TextAlign.start)),
                )
              ],
            ),
            Wrap(
              children: [
                Visibility(
                  visible: newPrice != 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: alignedTextWidget("Rs. $newPrice", const TextStyle(fontSize: 14.0, color: AppColors.kAccentColor, fontWeight: FontWeight.bold), 1, TextAlign.start,)),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: oldPrice != 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: alignedTextWidget("Rs. $oldPrice", const TextStyle(fontSize: 14.0, color: Colors.black12, fontWeight: FontWeight.normal, decoration: TextDecoration.lineThrough), 1, TextAlign.start)),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            )
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children:  [
            //     // Padding(
            //     //     padding: EdgeInsets.symmetric(horizontal: Dimensions.dim10),
            //     //     child: Text(titleText != "" ? titleText : "", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.kBlackColor, fontSize: 14.0, fontWeight: FontWeight.bold))),
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: Dimensions.dim10, vertical: Dimensions.dim5),
            //       child: Wrap(
            //         direction: Axis.vertical,
            //         children: [
            //           Text(newPrice, textAlign: TextAlign.start, style: TextStyle(color: AppColors.kPrimaryColor, fontSize: 12.0, fontWeight: FontWeight.bold,)),
            //           oldPrice != ""
            //               ? Text(oldPrice, textAlign: TextAlign.start, style: TextStyle(color: AppColors.black[300], fontSize: 12.0, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough))
            //               : Container(),
            //         ],
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
        Visibility(
          visible: getDiscountPercentage(oldPrice, newPrice) != 0,
          child: Positioned.fill(
            top: 0.0,
            right: 0.0,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(0)
                  ),
                  color: AppColors.kAccentColor,
                ),
                child: alignedTextWidget("${getDiscountPercentage(oldPrice, newPrice)}%", const TextStyle(fontSize: 12.0, color: AppColors.whiteColor, fontWeight: FontWeight.bold), 1, TextAlign.center),
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget myTextWidget(String text, TextStyle textStyle, int maxLine) {
  return Text(
    text,
    style: textStyle,
    maxLines: maxLine,
  );
}

TextStyle myTextStyle(double _fontSize, Color textColor, FontWeight fontWeight) {
  return TextStyle(
      fontWeight: fontWeight,
      fontSize: _fontSize,
      color: textColor
  );
}

Widget myCustomTextWidget(String text, double fontSize, Color textColor, FontWeight fontWeight) {
  return Text(
    text,
    style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight),
  );
}

Widget alignedTextWidget(String text, TextStyle textStyle, int maxLine, TextAlign textAlign) {
  return Text(
    text,
    style: textStyle,
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

int getDiscountPercentage(double old, double latest){
  double discount = 0;
  double difference = 0;
  difference = latest - old;

  if(old != 0){
    discount = (difference / old) * 100;
  }

  return discount.round();
}

Widget emptyContainer(context, String message){
  return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          child: alignedTextWidget("Empty", const TextStyle(fontSize: 14.0, color: AppColors.blackColor, fontWeight: FontWeight.bold), 3, TextAlign.center))
                  ),
                ],
              ),
              const SizedBox(
                height: 3.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          child: alignedTextWidget(message, const TextStyle(fontSize: 14.0, color: AppColors.blackColor, fontWeight: FontWeight.normal), 3, TextAlign.center))
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget myTextSpanWidget(String textTitle, String textData) {
  return Text.rich(
    TextSpan(
      text: textTitle,
      style: const TextStyle(color: AppColors.subHeading, fontSize: 14.0),
      children: [
        TextSpan(
          text: textData,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    ),
  );
}

Widget defaultLoader(context){
  return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: const Center(
        child: CircularProgressIndicator(color: Colors.pink)),
  );
}