import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const request = 'https://api.hgbrasil.com/finance?format=json&key=c7324096';

final rssController = TextEditingController();
final dolController = TextEditingController();
final eurController = TextEditingController();
final btcController = TextEditingController();

double dollar = 0;
double euro = 0;
double btc = 0;

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.green,
          primaryColor: Colors.amber,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber))))));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Conversor de Moedas'),
          centerTitle: true,
          backgroundColor: Colors.amber[600],
        ),
        backgroundColor: Colors.yellow[100],
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      'Carregando...',
                      style: TextStyle(color: Colors.amber[900], fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar...',
                        style:
                            TextStyle(color: Colors.amber[900], fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dollar = snapshot.data['USD']['buy'];
                    euro = snapshot.data['EUR']['buy'];
                    btc = snapshot.data['BTC']['buy'];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 145,
                            color: Colors.green[700],
                          ),
                          createField(
                              "Reais", "R\$", rssController, _realChanged),
                          Divider(
                            height: 8,
                          ),
                          createField(
                              "Dólares", "US\$", dolController, _dollarChanged),
                          Divider(
                            height: 8,
                          ),
                          createField("Euro", "€", eurController, _euroChanged),
                          Divider(
                            height: 8,
                          ),
                          createField(
                              "Bitcoins", "₿", btcController, _btcChanged),
                          Padding(
                            padding: EdgeInsets.only(top: 40, left: 15, right: 15),
                            child: Text(
                              "US\$ ${getValorAproximado(dollar)} | € ${getValorAproximado(euro)} | ₿ ${getValorAproximado(btc)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

String getValorAproximado(double valor) {
  return valor.toStringAsFixed(2);
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body)['results']['currencies'];
}

void _realChanged(String text) {
  if (text.isEmpty) {
    _clearAll();
    return;
  }
  double v = double.parse(text);
  dolController.text = (v / dollar).toStringAsFixed(2);
  eurController.text = (v / euro).toStringAsFixed(2);
  btcController.text = (v / btc).toStringAsFixed(10);
}

void _euroChanged(String text) {
  if (text.isEmpty) {
    _clearAll();
    return;
  }
  double v = double.parse(text);
  rssController.text = (v * euro).toStringAsFixed(2);
  dolController.text = (v * euro / dollar).toStringAsFixed(2);
  btcController.text = (v * euro / btc).toStringAsFixed(10);
}

void _dollarChanged(String text) {
  if (text.isEmpty) {
    _clearAll();
    return;
  }
  double v = double.parse(text);
  rssController.text = (v * dollar).toStringAsFixed(2);
  eurController.text = (v * dollar / euro).toStringAsFixed(2);
  btcController.text = (v * dollar / btc).toStringAsFixed(10);
}

void _btcChanged(String text) {
  if (text.isEmpty) {
    _clearAll();
    return;
  }
  double v = double.parse(text);
  rssController.text = (v * btc).toStringAsFixed(2);
  eurController.text = (v * btc / euro).toStringAsFixed(2);
  dolController.text = (v * btc / dollar).toStringAsFixed(10);
}

void _clearAll() {
  rssController.text = "";
  eurController.text = "";
  dolController.text = "";
  btcController.text = "";
}

Widget createField(
    String label, String symbol, TextEditingController controller, Function f) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.all(3),
        labelText: label,
        labelStyle: TextStyle(color: Colors.green),
        border: OutlineInputBorder(),
        prefixText: symbol),
    style: TextStyle(color: Colors.green, fontSize: 20),
    onChanged: f,
  );
}
