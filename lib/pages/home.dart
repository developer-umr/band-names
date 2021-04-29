import 'dart:io';
import 'package:bandnames/band.dart';
import 'package:bandnames/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    // TODO: implement initState
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload){
    print('active-bands: $payload');
    this.bands = (payload as List).map((item) => Band.fromMap(item)).toList();
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Anime List', style: TextStyle(color: Colors.black87),),
      backgroundColor: Colors.white,
        elevation: 1,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child:
                  socketService.serverStatus == ServerStatus.Online?
              Icon(Icons.offline_bolt, color: Colors.blue[300]):
              Icon(Icons.offline_bolt, color: Colors.red),
            )
          ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, i)=>this._bandTile(bands[i])
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band){
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_)=> socketService.socket.emit('delete-band', {"id": band.id}),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(8.0),
        child: Align(alignment: Alignment.centerLeft, child: Text('DeleteBand')),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text('${band.name}'),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
        onTap: ()=>socketService.socket.emit('vote-band', {"id":band.id}),
      ),
    );
  }

  _addNewBand(){
    print('add new Band');
    final textController=new TextEditingController();
    if(Platform.isAndroid){
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (_) => AlertDialog(
            title: Text('New band name'),
            content: TextField(
              controller: textController,

            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                onPressed: () => _addBandToList(textController.text),
              ),
            ],
          )
      );
    }
    else{
      showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
              title: Text('New band name'),
              content: CupertinoTextField(
                controller: textController,

              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Add'),
                  isDefaultAction: true,
                  onPressed: () => _addBandToList(textController.text),
                ),
                CupertinoDialogAction(
                  child: Text('Cerrar'),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
      );
    }


  }
  
  _addBandToList(String name){
    if(name.length>1){
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {"name": name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(
        width: double.infinity,
        height: 250,
        child: PieChart(dataMap: dataMap));
  }


}
