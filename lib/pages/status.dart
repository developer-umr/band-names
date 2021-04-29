import 'dart:convert';

import 'package:bandnames/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class StatusPage extends StatelessWidget {
  static final String routeName = 'status';

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    print('---> esta eb status page');
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Server status: ${socketService.serverStatus}')
        ],
      ),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          print('emit');
          Map<String, String> data = {"nombre":"Uriel","mensaje":"Mensaje enviado desde flutter"};
          socketService.socket.emit('flutter', json.encode(data));
        },
      ),
    );
  }
}
