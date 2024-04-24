import 'package:flutter/material.dart';

class loginwith extends StatelessWidget {
  final String route;
  final String text;
  final Function()? onTap;
  const loginwith(
      {super.key, required this.route, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Image.asset(
              route,
              height: 32,
            ),
            SizedBox(width: 8), // Espacio entre la imagen y el texto
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
