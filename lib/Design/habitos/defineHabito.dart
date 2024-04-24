import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';


class DefineHabitoScreen extends StatefulWidget {
  final Function(String) onHabitoChanged;
  final Function(int) onMetaChanged;

  DefineHabitoScreen({
    Key? key,
    required this.onHabitoChanged,
    required this.onMetaChanged, // Se añadió la coma aquí
  }) : super(key: key);

  @override
  _DefineHabitoScreenState createState() => _DefineHabitoScreenState();
}


class _DefineHabitoScreenState extends State<DefineHabitoScreen> {
  String _habito = '';
  String _descripcion = '';
  int meta = 0;
  FocusNode _focusNode = FocusNode();
  FocusNode _descripcionFocusNode = FocusNode();
  FocusNode _metaFocusNode = FocusNode();
  String ejemplo = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });

    _descripcionFocusNode.addListener(() {
      setState(() {});
    });

    _metaFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _descripcionFocusNode.dispose();
    _metaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ejemplo = Habito.evaluateProgress == 'valor numerico'
        ? 'e.j., leer 20 páginas al día'
        : 'e.j., leer';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Text(
                  'Define tu hábito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                focusNode: _focusNode,
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(_focusNode);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Hábito',
                  labelStyle: TextStyle(
                    color: _focusNode.hasFocus
                        ? Color.fromARGB(255, 24, 85, 142)
                        : Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 24, 85, 142)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _habito = value;
                    Habito.habitName = _habito;
                  });
                  widget.onHabitoChanged(value);
                },
              ),
              SizedBox(height: 20.0),
              if (Habito.evaluateProgress == 'valor numerico')
                TextFormField(
                  focusNode: _metaFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Meta',
                    labelStyle: TextStyle(
                      color: _metaFocusNode.hasFocus
                          ? Color.fromARGB(255, 24, 85, 142)
                          : Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 24, 85, 142)),
                    ),
                  ),
                  keyboardType: TextInputType
                      .number, // Esto indica que se debe mostrar el teclado numérico

                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      meta = int.tryParse(value)!;
                      Habito.meta = meta;
                    });
                    widget.onMetaChanged(meta = int.tryParse(value)!);
                  },
                ),
              SizedBox(height: 20.0),
              Text(
                ejemplo,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                focusNode: _descripcionFocusNode,
                decoration: InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  labelStyle: TextStyle(
                    color: _descripcionFocusNode.hasFocus
                        ? Color.fromARGB(255, 24, 85, 142)
                        : Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 24, 85, 142)),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _descripcion = value;
                    Habito.habitDescription = _descripcion;
                  });
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
