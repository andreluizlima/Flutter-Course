import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  String _infoText = 'Preencha os dados';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Icon _icon = Icon(FontAwesomeIcons.smile);

  void _resetFields() {
    pesoController.text = "";
    alturaController.text = "";

    setState(() {
      _infoText = 'Preencha os dados';
      _formKey = GlobalKey<FormState>();
      _icon = Icon(FontAwesomeIcons.smile, size: 60, color: Colors.deepPurple,);
    });
  }

  void calculate() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text);

      double imc = peso / (altura * altura);

      print(imc);

      if (imc < 18.6) {
        _icon = Icon(FontAwesomeIcons.frown, size: 60, color: Colors.deepPurple,);
        _infoText = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _icon = Icon(FontAwesomeIcons.smile, size: 60, color: Colors.deepPurple,);
        _infoText = "Peso ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _icon = Icon(FontAwesomeIcons.meh, size: 60, color: Colors.deepPurple,);
        _infoText = "Pouco acima do peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _icon = Icon(FontAwesomeIcons.frown, size: 60, color: Colors.deepPurple,);
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _icon = Icon(FontAwesomeIcons.sadTear, size: 60, color: Colors.deepPurple,);
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else {
        _icon = Icon(FontAwesomeIcons.sadCry, size: 60, color: Colors.deepPurple,);
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _resetFields();
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.deepPurpleAccent,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.deepPurpleAccent)),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.deepPurpleAccent, fontSize: 25),
                  controller: pesoController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Preencha o peso!!";
                    }
                  },
                ),
                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Altura (kg)",
                        labelStyle: TextStyle(color: Colors.deepPurpleAccent)),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.deepPurpleAccent, fontSize: 25),
                    controller: alturaController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Preencha a altura!!";
                      }
                    }),
                Padding(
                  padding: EdgeInsets.only(top: 24, bottom: 20),
                  child: Container(
                    height: 55,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          calculate();
                        }
                      },
                      child: Text(
                        "CALCULAR",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.deepPurple[300], fontSize: 22),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: _icon,

                )
              ],
            ),
          ),
        ));
  }
}
