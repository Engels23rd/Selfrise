import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/components/mySlides.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class InputsLogin extends StatelessWidget {
  final TextEditingController? controller;
  final String hinttxt;
  final bool obscuretxt;
  final IconData icono;
  final String? Function(String?)? validator;

  const InputsLogin(
      {super.key,
      this.controller,
      required this.hinttxt,
      required this.obscuretxt,
      required this.icono,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscuretxt,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.buttonCoLor, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          fillColor: Colors.grey.shade300,
          filled: true,
          prefixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              icono,
            ),
          ),
          hintText: hinttxt,
          hintStyle: TextStyle(color: Colors.grey[500]),
          isDense: true, // Added this
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}

class InputsRegister extends StatelessWidget {
  final TextEditingController? controller;
  final String hinttxt;
  final bool obscuretxt;
  final IconData icono;
  final String? Function(String?)? validator;

  const InputsRegister(
      {super.key,
      required this.controller,
      required this.hinttxt,
      required this.obscuretxt,
      this.validator,
      required this.icono});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscuretxt,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(
            icono,
          ),
        ),
        hintText: hinttxt,
        hintStyle: TextStyle(color: Colors.grey[500]),
        isDense: true, // Added this
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  const CustomTextInput({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}

class ImputDate extends StatefulWidget {
  final DateTime? selectedDate;
  final IconData icono;
  final TextEditingController? datecontroller;
  final String? Function(DateTime?)? validator;

  const ImputDate(
      {Key? key,
      required this.selectedDate,
      required this.icono,
      required this.datecontroller,
      this.validator})
      : super(key: key);

  @override
  _ImputDateState createState() => _ImputDateState();
}

class _ImputDateState extends State<ImputDate> {
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: widget.datecontroller,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: 'YYYY/MM/DD',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: Icon(
          widget.icono,
        ),
      ),
      initialValue: widget.selectedDate,
      format: DateFormat("dd/MM/yyyy"),
      onShowPicker: (BuildContext context, DateTime? currentValue) async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: currentValue ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          return picked;
        } else {
          return currentValue;
        }
      },
    );
  }
}
