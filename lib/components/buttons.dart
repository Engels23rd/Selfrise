import 'package:flutter/material.dart';
import '../Colors/colors.dart';
import 'package:rive/rive.dart';

class ButtonsLogin extends StatelessWidget {
  final Function()? ontap;
  final String txt;

  const ButtonsLogin({super.key, required this.ontap, required this.txt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: const BoxDecoration(
          color: AppColors.buttonCoLor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            txt,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;

  const NextButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(40, 115, 185, 1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;

  const CustomBackButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          // Cambiar el espacio horizontal
          decoration: BoxDecoration(
            color: AppColors.buttonCoLor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//BOTON DE MENU
class menubtn extends StatelessWidget {
  const menubtn({
    super.key,
    required this.press,
    required this.riveOnInit,
  });

  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.only(left: 20, top: 10),
        height: 45,
        width: 45,
        decoration: const BoxDecoration(
            color: AppColors.buttonCoLor,
            shape: BoxShape.circle,
          ),
        child: Center(
          child: Transform.scale(
            scale: 0.7, // Ajusta este valor según sea necesario
            child: RiveAnimation.asset(
              "assets/icon-menu/menu_button.riv",
              onInit: riveOnInit,
            ),
          ),
        ),
      ),
    ));
  }
}
