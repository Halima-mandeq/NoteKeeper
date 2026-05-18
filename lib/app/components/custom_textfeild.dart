import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/user/controllers/user_controller.dart';
import '../utils/exports.dart';

class CustomTextFeilds extends StatelessWidget {
  final String hintText;
  final IconData? iconData;
  final IconData? passIcon;
  final void Function()? onTap;
  final bool showPassword;
  final void Function()? onPasswordVisibilityToggle;
  final TextEditingController controller;
  final bool isEmail;
  final bool ispassword;
  final TextInputType? keyboardType;
  final String? phoneCode;
  final String? flagEmoji;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final bool readOnly;

  const CustomTextFeilds({
    super.key,
    required this.hintText,
    this.iconData,
    this.passIcon,
    this.onTap,
    this.showPassword = false,
    this.onPasswordVisibilityToggle,
    required this.controller,
    this.isEmail = false,
    this.ispassword = false,
    this.keyboardType,
    this.phoneCode,
    this.flagEmoji,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (e) {
        return TextFormField(
          scrollPadding: const EdgeInsets.all(0),
          readOnly: readOnly,
          keyboardType:
              keyboardType ??
              (ispassword ? TextInputType.visiblePassword : null),
          textCapitalization: textCapitalization,
          textInputAction: textInputAction ?? TextInputAction.next,
          obscuringCharacter: '*',
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: ispassword && !showPassword,
          onChanged: onChanged,
          validator: (value) {
            if (value!.isEmpty || value == '') {
              return '';
            } else if (isEmail && !e.isEmailValid(value)) {
              return 'Whoops! Fadlan geli email-kaga Saxan';
            } else if (ispassword ? value.length < 8 : false) {
              return "Whoops! Password needs at least 8 characters.";
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blueGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: NAppColor.kSecondColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            hintText: hintText,
            hintStyle: style(
              fontSize: 14,
              color: Get.isDarkMode
                  ? Colors.grey.shade300.withValues(alpha: 0.6)
                  : NAppColor.kTextStyleColor.withValues(alpha: 0.6),
            ),

            // ✅ Conditional prefix (for phone input)
            prefixIcon: iconData == Icons.phone
                ? GestureDetector(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            flagEmoji ?? '',
                            style: style(
                              fontSize: 18,
                              color: NAppColor.kTextStyleColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+$phoneCode',
                            style: style(
                              fontSize: 14,
                              color: NAppColor.kTextStyleColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(height: 20, width: 1, color: Colors.grey),
                        ],
                      ),
                    ),
                  )
                : Icon(iconData, size: 24, color: NAppColor.kTextStyleColor),

            // ✅ Password toggle (if needed)
            suffixIcon: ispassword
                ? IconButton(
                    onPressed: onPasswordVisibilityToggle,
                    tooltip: showPassword
                        ? 'Hide password'
                        : 'Show password',
                    icon: Icon(
                      passIcon ??
                          (showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                      size: 24,
                      color: NAppColor.kTextStyleColor,
                    ),
                  )
                : null,
          ),
          style: style(
            fontSize: 15,
            color: Get.isDarkMode
                ? NAppColor.kbgColor
                : NAppColor.kTextStyleColor,
          ),
        );
      },
    );
  }
}
