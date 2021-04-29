import 'dart:io';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}
class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  ServerStatus get serverStatus=>this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService(){
    print('Se ejccuta socket service');
    this._initConfig();
  }

  void _initConfig(){

    print('--initconfig socket');
      this._socket = IO.io('https://dbfcabfb9f68.ngrok.io/', {
        'transports':['websocket'],
        'autoConnect': true
      });

    print('---->connected: ${this._socket.connected}');
    print('---->diconnected ${this._socket.disconnected}');
this._socket.on('connect', (_) {
  print('------------>connect');
});
    this._socket.onConnect((_) {
      print('connect');
      this._socket.emit('msg', 'test');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('nuevo-mensaje', (payload){
      print('Nuevo mensaje: $payload');
      print(payload.containsKey('nombre')?payload['nombre']:'No hay');
    });
    this._socket.onDisconnect((_) {
      print('Disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('fromServer', (_) => print(_));
    this._socket.on('active-bands', (bands){

    });
  }
}