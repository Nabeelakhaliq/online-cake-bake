import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_cake_ordering/config/size_config.dart';
import 'package:online_cake_ordering/models/cart_model.dart';
import 'package:online_cake_ordering/models/product_model.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:online_cake_ordering/resources/image_assets.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';
import 'package:online_cake_ordering/screens/user/select_shipping_address.dart';
import 'common_widgets.dart';
import 'icon_widgets.dart';
import 'image_widgets.dart';

class CustomRaisedButton extends StatelessWidget {
  final String buttonText;

  const CustomRaisedButton({Key? key, required this.buttonText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 138, 120, 1),
            Color.fromRGBO(255, 114, 117, 1),
            Color.fromRGBO(255, 63, 111, 1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(50),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          primary: AppColors.whiteColor,
          backgroundColor: AppColors.kAccentColor,
        ),
        onPressed: press,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {

  final String text;
  final VoidCallback onPress;

  const DefaultButton({Key? key, required this.text, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: FlatButton(
          color: AppColors.primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Text(
          text,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
          onPressed: onPress
      ),
    );
  }
}

class SmallButton extends StatelessWidget {

  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPress;

  const SmallButton({Key? key, required this.text, required this.onPress, required this.color, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: color,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.width * 0.042,
          ),
        ),
        onPressed: onPress
    );
  }
}

class DefButton extends StatelessWidget {

  final String text;
  final VoidCallback onPress;

  const DefButton({Key? key, required this.text, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        color: AppColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.normal,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
        onPressed: onPress
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(5)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: child,
    );
  }
}

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cartModel,
  }) : super(key: key);

  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cartModel.imageUrl),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cartModel.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "\$${cartModel.price}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.kAccentColor),
                children: [
                  TextSpan(
                      text: " x${cartModel.quantity}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class CheckoutCard extends StatelessWidget {

  const CheckoutCard({Key? key, required this.totalPrice, required this.noOfItems, required this.cartList}) : super(key: key);

  final List<ProductModel> cartList;
  final double totalPrice;
  final int noOfItems;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(10),
        horizontal: getProportionateScreenWidth(30),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(ImageAssets.iconsReceiptIcon),
                ),
                const Spacer(),
                const Text("Add voucher code"),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.kAccentColor,
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "Rs. $totalPrice",
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: CustomButton(
                    text: "Check Out",
                    press: () async {
                      if(cartList.isNotEmpty) {
                        await saveData(context);
                      }
                      else {
                        Fluttertoast.showToast(msg: "Please add item(s) into cart!");
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  saveData(BuildContext context) {
    StringAssets.noOfItems = noOfItems;
    StringAssets.subTotal = totalPrice.toDouble();
    StringAssets.totalPrice = (totalPrice + StringAssets.shippingFee).toDouble();

    if(StringAssets.cartProductsList.isNotEmpty) {
      StringAssets.cartProductsList.clear();
    }

    StringAssets.cartProductsList.addAll(cartList);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShippingAddressSelection()));
  }

}

class IconTextButton extends StatelessWidget {

  final String text;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData iconData;
  final double iconSize;
  final MainAxisAlignment alignment;
  final VoidCallback onPress;

  const IconTextButton({Key? key, required this.text, required this.backgroundColor, required this.fontSize, required this.fontWeight, required this.iconData, required this.iconSize, required this.alignment, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50.0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: RaisedButton(
        onPressed: onPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: alignment,
              children: [
                IconWidgets.sizedIcon(iconData, AppColors.kAccentColor, iconSize),
                const SizedBox(width: 10.0),
                customTextWidget(text, fontSize, AppColors.kAccentColor, fontWeight)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefIconTextButton extends StatelessWidget {

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final IconData iconData;
  final VoidCallback onPress;

  const DefIconTextButton({Key? key, required this.text, required this.fontSize, required this.fontWeight, required this.iconData, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50.0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: RaisedButton(
        onPressed: onPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.centerLeft,
                  end: FractionalOffset.centerRight,
                  colors: [
                    AppColors.kPrimaryColor!.withOpacity(0.8),
                    AppColors.kAccentColor,
                  ],
                  stops: const [
                    0.0,
                    0.6
                  ]
              ),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconWidgets.sizedIcon(iconData, Colors.white, 30.0),
                const SizedBox(width: 10.0),
                customTextWidget(text, fontSize, AppColors.whiteColor, fontWeight)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefImageTextButton extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color bgColor;
  final FontWeight fontWeight;
  final String imageUrl;
  final VoidCallback onPress;

  const DefImageTextButton({Key? key, required this.text, required this.fontSize, required this.bgColor, required this.fontWeight, required this.imageUrl, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50.0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: RaisedButton(
        onPressed: onPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customImageWidgets(imageUrl),
                ),
                const SizedBox(width: 5.0),
                customTextWidget(text, fontSize, AppColors.blackColor, fontWeight)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputAction textInputAction;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextStyle style;
  final Color cursorColor;
  final InputDecoration decoration;
  // final String Function(String?) validator;
  // final void Function(String?) onSaved;
  final void Function(String?) onFieldSubmitted;
  final void Function() onTap;

  const MyInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.textInputAction,
    required this.autofocus,
    required this.keyboardType,
    required this.style,
    required this.cursorColor,
    required this.decoration,
    // required this.validator,
    // required this.onSaved,
    required this.onFieldSubmitted,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: textInputAction,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      style: style,
      maxLines: 1,
      maxLength: 5,
      cursorColor: cursorColor,
      decoration: decoration,
      // validator: validator ?? (String? validatorValue) {
      //   return null;
      // },
      // onChanged: onChanged ?? (value){},
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
    );
  }
}

// class DropDownWidget extends StatelessWidget {
//
//   const DropDownWidget({
//     Key? key,
//     required this.elevation,
//     required this.hintText,
//     required this.onChange,
//     required this.itemsList,
//   }) : super(key: key);
//
//   final int elevation;
//   final String hintText;
//   final Function onChange;
//   final List<String> itemsList;
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//       elevation: elevation,
//       underline: Container(
//         decoration: ShapeDecoration(
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 1.0, style: BorderStyle.solid),
//             borderRadius: BorderRadius.all(Radius.circular(5.0)),
//           ),
//         ),
//       ),
//       hint: customTextWidget(hintText, 14.0, Colors.black12, FontWeight.normal),
//       items:  itemsList.map<DropdownMenuItem<String>>((status) {
//         return DropdownMenuItem(
//             value: status,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 customTextWidget(status, 14.0, Colors.black, FontWeight.bold)
//               ],
//             )
//         );
//       }).toList(),
//       onChanged: onChange,
//     );
//   }
// }