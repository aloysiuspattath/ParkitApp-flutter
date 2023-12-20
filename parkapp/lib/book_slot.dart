import 'dart:convert';
import 'dart:math';
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookSlotPage extends StatefulWidget {
  final String userid;
  final String selectedDate;
  final String startTime;
  final String endTime;
  const BookSlotPage({Key? key, required this.userid,required this.selectedDate,required this.startTime,required this.endTime}) : super(key: key);

  @override
  State<BookSlotPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BookSlotPage>{


   
  int columns = 2;
  int rows = 6;
  List<Map> plots = [];
  var slotList = [];
  List<int> booked=[];

  Future<Map<String, dynamic>> getSlotList(String selectedDate) async{
          final Map<String, dynamic> data = {
            "date":selectedDate,
            "start":widget.startTime,
            "end":widget.endTime
          };
        var res = await http.post(
        Uri.parse('http://'+serverIP+'/slots'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },body: jsonEncode(data));
        
       return {"code": res.statusCode,"body":res.body};
    
  }

    Future<void> bookSlot(int id) async{
            final Map<String, dynamic> data = {
            "slotid":id,
            "userid":widget.userid,
            "date":widget.selectedDate,
             "start":widget.startTime,
            "end":widget.endTime
          };
          //print(userid);
         var res = await http.post(
        Uri.parse('http://'+serverIP+'/updateslot'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },body: jsonEncode(data)
        );

         getSlotList(widget.selectedDate)
        .then((resp) => setState(() {
           
              var response=json.decode(resp["body"]);
              slotList=response['data'];
              // print(slotList);
              for(int i=0;i<slotList.length;i++){
                booked.add(slotList[i][1]);
                print(slotList[i][0]);
              }
              
            }))
        .catchError((error) => setState(() {}));
        // setState(() {
             
        // });
  }

  @override
  void initState() {

        getSlotList(widget.selectedDate)
        .then((resp) => setState(() {
           
              var response=json.decode(resp["body"]);
              slotList=response['data'];
              print(slotList);
              for(int i=0;i<slotList.length;i++){
                booked.add(slotList[i][1]);
                print(slotList[i][0]);
              }
              
            }))
        .catchError((error) => setState(() {}));
      
        

    for (int i = 0; i < columns * rows; i++) {
      Map temp = {
        'id': i,
        'name': String.fromCharCode(65 + i),
        'isfree': Random().nextBool(),
      };
      plots.add(temp);
    }
    super.initState();
  }

  Future<void> update(int index) async {
    String displayText = '';
    index+=1;
    if (!booked.contains(index)) {
      displayText = 'Book The Slot';
    } else {
      displayText = 'Already Booked';
    }
    bool didChange = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              ListTile(
                title: Text(displayText),
                trailing: FilledButton(
                  onPressed: () {
                    //  TODO: Add API calls
                    if(displayText=='Already Booked'){
                       Navigator.of(context).pop(false);
                    }
                    else{
                    Navigator.of(context).pop(true);
                     } // TODO: Return if API calls return successful state change
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        );
      },
    );
    if(didChange) {
      var status;


      
      // if(plot['isfree']){
      //   status='booked';
      // }
      // else{
      //   status='free';
      // }
      //var id=plot['id'];
      

       setState(() {
        bookSlot(index);
      // booked.add(index);
      // booked.sort();
        //plots[plot['id']]['isfree'] = !plots[plot['id']]['isfree'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        title: const Text(
          "PARKit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
      ),
        body: Column(
          children: [
            Row(
              children: [

              ],
            ),
            GridView.count(
                crossAxisCount: columns,
                childAspectRatio: 2,
                padding: const EdgeInsets.all(32),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                children: List.generate(columns * rows, (index) {
                  if (!booked.contains(index+1)) {
                    
                    return FilledButton.tonal(
                      onPressed: () => update(index),
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(plots[index]['name']),
                    );
                  } else {
                    return FilledButton(
                      onPressed: () => update(index),
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(plots[index]['name']),
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }
}
