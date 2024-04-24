// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import '../Design/login/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


final controller = PageController();

Widget buildSlide(BuildContext context, String imagePath, String text,
    {bool withButtons = false}) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (withButtons != true) ...[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const WormEffect(
                  spacing: 8,
                  dotColor: Colors.blueGrey,
                  activeDotColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
        if (withButtons) ...[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                CustomButton(
                  text: 'Ingresar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  backgroundColor: AppColors.buttonCoLor,
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? backgroundColor;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
          backgroundColor: backgroundColor,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
