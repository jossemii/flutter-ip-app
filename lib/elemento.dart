import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_slidable/flutter_slidable.dart';


class Elemento extends StatefulWidget {
  final String ip;
  final int port;

  const Elemento({
    Key? key,
    required this.ip,
    required this.port,
  }) : super(key: key);

  @override
  _ElementoState createState() => _ElementoState();
}

class _ElementoState extends State<Elemento> {
  late Icon _icon;
  late Text _text;

  @override
  void initState() {
    super.initState();
    _icon = const Icon(Icons.bolt);
    _text = Text('${widget.ip}:${widget.port}');
    _reload(false);
    Timer.periodic(const Duration(minutes: 1), (timer) {
      print("Execute reload other time.");
      _reload(true);
    });
  }

  void _reload(without_pob) async {
    if (await connect()) {
      setState(() {
        _icon = const Icon(
          Icons.offline_bolt,
          color: Colors.green,
        );
      });
    } else {
      setState(() {
        _icon = const Icon(
          Icons.offline_bolt,
          color: Color.fromARGB(255, 175, 96, 76),
        );
      });
    }
  
    if(!without_pob) {
      Navigator.pop(context);
    }
  }

  Future<bool> connect() async {
    if (kIsWeb) {
      try {
        await http.get(Uri.parse('http://${widget.ip}:${widget.port}'));
        return true;
      } catch (e) {
        return false;
      }
    } 
    else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      try {
        final addresses = await InternetAddress.lookup(widget.ip);
        await Socket.connect(addresses.first, widget.port, timeout: const Duration(seconds: 2));
        return true;
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error de conexión"),
            content: Text("No se pudo establecer una conexión con el host."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Aceptar"),
              ),
            ],
          ),
        );
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
         /*SlidableAction(
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.refresh_outlined,
            label: 'Save',
            onPressed: _reload,
          ),
        */
        ],
      ),
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: _icon,
          title: _text,
          subtitle: const Text('SlidableDrawerDelegate'),
        ),
      ),
    );
  }
}