import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomContainerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final Color buttonColor;
  final double buttonRadius;
  final String buttonText;
  final FontWeight buttonTextFontWeight;
  final String buttonTextFontFamily;
  final double buttonTextFontSize;
  final Color buttonTextColor;
  final String? svgAsset;
  const CustomContainerButton({super.key,required this.onPressed, required this.buttonHeight, required this.buttonWidth, required this.buttonColor, required this.buttonRadius, required this.buttonText, required this.buttonTextFontWeight, required this.buttonTextFontFamily, required this.buttonTextFontSize, required this.buttonTextColor, this.svgAsset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgAsset != null) ...[
                SvgPicture.asset(
                  svgAsset!,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8), // spacing between icon and text
              ],
              Text(buttonText,style: TextStyle(
                fontSize: buttonTextFontSize,
                fontFamily: buttonTextFontFamily,
                fontWeight: buttonTextFontWeight,
                color: buttonTextColor,
              ),),
            ],
          ),
        )
      ),
    );
  }
}
