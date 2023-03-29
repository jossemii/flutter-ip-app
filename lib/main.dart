import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'elemento.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: const MaterialColor(0xffe5c601, {
          50: Color(0xfffffde7),
          100: Color(0xfffff9c4),
          200: Color(0xfffff59d),
          300: Color(0xfffff176),
          400: Color(0xffffee58),
          500: Color(0xffe5c601),
          600: Color(0xffffca28),
          700: Color(0xffffc107),
          800: Color(0xffffb300),
          900: Color(0xffffa000),
        }),
      ),
      home: const IPList(title: 'Flutter Node - Alpha version'),
    );
  }
}

class IPList extends StatefulWidget {
  const IPList({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<IPList> createState() => IPListState();
}

class ElementoData {
  String ip;
  int port;

  ElementoData({required this.ip, required this.port});
}


class IPListState extends State<IPList> {
  final List<ElementoData> _elementos = [];
  String _inputIp = '';
  int _intputPort = 0;
  
  void _addItem() async {
          setState(() {
              _elementos.add(
                  ElementoData(ip: _inputIp, port: _intputPort)
              );
          });
      }

  void _clearItems() {
    setState(() {
      _elementos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _elementos.length,
          itemBuilder: (BuildContext context, int index) {
            final elemento = _elementos[index];
            return Elemento(
              ip: elemento.ip,
              port: elemento.port,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _clearItems,
            tooltip: 'Limpiar la lista',
            child: const Icon(Icons.delete),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  _inputIp = '';
                  _intputPort = 0;
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            onChanged: (text) {
                              _inputIp = text;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Introducir IP',
                            ),
                            inputFormatters: [],
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _intputPort = int.parse(value);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Introduce el puerto',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addItem,
                            child: Text('Agregar'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: 'Añadir nuevo elemento',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.account_tree_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.account_balance_wallet)),
          ],
        ),
      ),
    );
  }
}
