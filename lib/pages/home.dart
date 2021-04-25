import 'dart:io';
import 'package:bandnames/band.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id:'1', name: 'naruto', votes: 10),
    Band(id:'2', name: 'Attack of titan', votes: 9),
    Band(id:'3', name: 'Demon Slayer', votes: 9),
    Band(id:'3', name: 'Moshuko tensei', votes: 10),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Anime List', style: TextStyle(color: Colors.black87),),),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i)=>this._bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band){

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('$direction');
        //llamar el borrado en el serve
        print('${band.id}');
      },
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
        onTap: (){
          print('${band.name}');
        },
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
        builder: (BuildContext dialogContext) {
          return AlertDialog(
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
          );
        },
      );
    }
    else{
      showCupertinoDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CupertinoAlertDialog(
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
            );
          }
      );
    }


  }
  
  _addBandToList(String name){
    if(name.length>1){
      print('-->$name');
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {

      });
    }

    Navigator.pop(context);
  }
}
