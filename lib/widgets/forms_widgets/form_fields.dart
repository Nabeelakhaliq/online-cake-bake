import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:online_cake_ordering/resources/app_colors.dart';
import 'package:online_cake_ordering/resources/string_assets.dart';

class FormFieldsWidgets {
  FormFieldsWidgets._();

  static Widget defHeadingFormField(BuildContext context, String headingText) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      children: [
        Text(
          headingText,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.kAccentColor,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ],
    );
  }

  static Widget headingFormField(BuildContext context, String headingText) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      children: [
        Text(
          headingText,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ],
    );
  }

  static Widget mobileFormField(TextEditingController mobileController, BuildContext buildContext) {
    return Stack(
        children:[
          Container(
            height:52,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: InternationalPhoneNumberInput(
              inputDecoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent,)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent,)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent)),
                fillColor: AppColors.lightGrey,
                contentPadding: EdgeInsets.fromLTRB(
                    15, 15, 0, 15),
                // filled: true,
                hintText: "3107823091",
                hintStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: 16,
                  letterSpacing: 3.0,
                ),
              ),
              spaceBetweenSelectorAndTextField: 0,
              onInputChanged: (PhoneNumber number) {},
              onInputValidated: (bool value) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
                trailingSpace: false
              ),
              // ignoreBlank: false,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              selectorTextStyle: const TextStyle(color: Colors.black),
              textFieldController: mobileController,
              formatInput: false,
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
              inputBorder: const OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                debugPrint('On Saved: $number');
              },
              onFieldSubmitted: (_) => FocusScope.of(buildContext).nextFocus(),
            ),
          ),
        ]
    );
  }

  static Widget textFormField(BuildContext context, TextEditingController textController, TextInputType textInputType, TextInputAction textInputAction, String _hintText) {
    return TextFormField(
      controller: textController,
      autofocus: true,
      showCursor: true,
      cursorColor: AppColors.primaryColor,
      onTap: (){},
      style: const TextStyle(
        fontSize: 26.7,
        color: AppColors.blackColor,
      ),
      keyboardType: textInputType,
      textInputAction: TextInputAction.done,
      //textInputAction: textInputAction,
      onChanged: (value) {
        // if(value.isNotEmpty)
        // {
        //   FocusScope.of(context).nextFocus();
        // }
        // else
        // {
        //   FocusScope.of(context).previousFocus();
        // }
      },
      onFieldSubmitted: (value) {
        if (kDebugMode) {
          debugPrint("$textController : $value");
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
        else {
          return null;
        }
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent,)),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent,)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        filled: true,
        fillColor: AppColors.lightGrey,
        // hintText: "0",
        hintText: _hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 26.7,
        ),
      ),
    );
  }

  static Widget titleFormField(TextEditingController textController, TextInputType textInputType, TextInputAction textInputAction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: textController,
        textInputAction: textInputAction,
        autofocus: false,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          //labelStyle: AppStyles.labelTextStyle,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColors.blackColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColors.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColors.blackColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColors.lightGreyLite,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 1.0,
              color: AppColors.blackColor,
            ),
          ),
          labelText: "Title",
          alignLabelWithHint: true,
          hintText: "Enter Title",
          //hintStyle: AppStyles.kGreyColorTextStyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Required";
          }  else {
            return null;
          }
        },
        onSaved: (value) {
          //topicTitle = value;
        },
        onChanged: (value) {
          //topicTitle = value;
        },
        onFieldSubmitted: (_) {},
      ),
    );
  }

}

class NameFormField extends StatefulWidget {

  final TextEditingController nameController;
  const NameFormField({Key? key, required this.nameController}) : super(key: key);

  @override
  _NameFormFieldState createState() => _NameFormFieldState();
}

class _NameFormFieldState extends State<NameFormField> {
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Name Required';
        } else {
          return null;
        }
      },
      onChanged: (value) {},
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(
                    10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        fillColor: AppColors.lightGrey,
        filled: true,
        suffixIcon: widget.nameController.text.isNotEmpty
            ? IconButton(
          onPressed: () {
            setState(() {
              widget.nameController.clear();
            });
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.primaryColor,
          ),
        )
            : null,
        hintText: "Full Name",
        contentPadding: const EdgeInsets.fromLTRB(
            15, 15, 0, 15),
        hintStyle: const TextStyle(
          color: AppColors.grey,
          fontSize: 16.7,
        ),
      ),
    );
  }
}

class EmailFormField extends StatefulWidget {

  final TextEditingController emailController;
  final bool isEditable;
  const EmailFormField({Key? key, required this.emailController, required this.isEditable}) : super(key: key);

  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      enabled: widget.isEditable,
      autovalidateMode: AutovalidateMode.disabled,
      controller: widget.emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = RegExp(StringAssets.emailPattern);
        if (value!.isEmpty) {
          return 'Email Required';
        }
        else {
          if (!regex.hasMatch(value)) {
            return "Please Enter a valid Email";
          } else {
            return null;
          }
        }
      },
      onChanged: (value) {},
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent,)),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent,)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        fillColor: AppColors.lightGrey,
        filled: true,
        suffixIcon: widget.emailController.text.isNotEmpty
            ? IconButton(
          onPressed: () {
            setState(() {
              widget.emailController.clear();
            });
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.primaryColor,
          ),
        )
            : const Icon(
          Icons.clear,
          color: Colors.transparent,
        ),
        hintText: "info@gmail.com",
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
        hintStyle: const TextStyle(
          color: AppColors.grey,
          fontSize: 16.7,
        ),
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {

  final TextEditingController passwordController;
  const PasswordFormField({Key? key, required this.passwordController}) : super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  @override
  Widget build(BuildContext context) {

    bool _isObscure = true;

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller:widget.passwordController,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscure,
      obscuringCharacter: "*",
      validator: (value) {
        if(value!.isEmpty){
          return  "Password Required";
        }
        else{
          return null;
        }
      },
      onChanged: (value) {},
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent,)),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent,)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.transparent)),
        fillColor: AppColors.lightGrey,
        filled: true,
        suffixIcon: widget.passwordController.text.isNotEmpty
            ? IconButton(
          onPressed: () {
            setState(() {
              widget.passwordController.clear();
            });
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.primaryColor,
          ),
        )
            : null,
        prefixIcon: IconButton(
            icon: Icon(_isObscure == true ? Icons.visibility : Icons.visibility_off),
            color: _isObscure == false ? AppColors.primaryColor : AppColors.grey,
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
        hintText: "************",
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
        hintStyle: const TextStyle(
          color: AppColors.grey,
          fontSize: 20.7,
        ),
      ),
    );
  }
}

class DefaultFormField extends StatefulWidget {

  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextCapitalization textCapitalization;
  final TextEditingController textEditingController;
  final String hintText;
  final String nullError;

  const DefaultFormField({Key? key, required this.textEditingController, required this.inputType,
    required this.inputAction, required this.textCapitalization, required this.hintText,
    required this.nullError}) : super(key: key);

  @override
  _DefaultFormFieldState createState() => _DefaultFormFieldState(textEditingController: textEditingController, inputAction: inputAction, inputType: inputType, hintText: hintText, nullError: nullError, textCapitalization: textCapitalization);
}

class _DefaultFormFieldState extends State<DefaultFormField> {

  TextInputAction inputAction;
  TextInputType inputType;
  TextCapitalization textCapitalization;
  TextEditingController textEditingController;
  String hintText;
  String nullError;

  _DefaultFormFieldState({Key? key, required this.textEditingController, required this.inputType,
    required this.inputAction, required this.textCapitalization, required this.hintText,
    required this.nullError});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.perm_device_info, color: AppColors.kAccentColor),
      title: TextFormField(
        textInputAction: inputAction,
        keyboardType: inputType,
        controller: textEditingController,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.grey),
          border: InputBorder.none,
        ),
        validator: (value) {
          if(value!.isEmpty){
            return nullError;
          }
          else{
            return null;
          }
        },
        onChanged: (value) {},
      ),
    );
  }
}

class CustomFormField extends StatefulWidget {

  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextCapitalization textCapitalization;
  final TextEditingController textEditingController;
  final String hintText;
  final String nullError;

  const CustomFormField({Key? key, required this.textEditingController, required this.inputType,
    required this.inputAction, required this.textCapitalization, required this.hintText,
    required this.nullError}) : super(key: key);

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState(textEditingController: textEditingController, inputAction: inputAction, inputType: inputType, hintText: hintText, nullError: nullError, textCapitalization: textCapitalization);
}

class _CustomFormFieldState extends State<CustomFormField> {

  TextInputAction inputAction;
  TextInputType inputType;
  TextCapitalization textCapitalization;
  TextEditingController textEditingController;
  String hintText;
  String nullError;

  _CustomFormFieldState({Key? key, required this.textEditingController, required this.inputType,
    required this.inputAction, required this.textCapitalization, required this.hintText,
    required this.nullError});

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      autovalidateMode: AutovalidateMode.disabled,
      controller: textEditingController,
      textInputAction: inputAction,
      keyboardType: inputType,
      textCapitalization: textCapitalization,
      validator: (value) {
        if (value!.isEmpty) {
          return nullError;
        } else {
          return null;
        }
      },
      onChanged: (value) {},
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(
                    10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
        fillColor: AppColors.lightGrey,
        filled: true,
        suffixIcon: textEditingController.text.isNotEmpty
            ? IconButton(
          onPressed: () {
            setState(() {
              textEditingController.clear();
            });
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.primaryColor,
          ),
        )
            : null,
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(
            15, 15, 0, 15),
        hintStyle: const TextStyle(
          color: AppColors.grey,
          fontSize: 16.7,
        ),
      ),
    );
  }
}