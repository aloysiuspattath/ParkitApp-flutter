import 'dart:math';
import 'dart:convert';
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'package:parkit/screens/login.dart';

class AdminSlotView extends StatefulWidget {
  final String selectedDate;
  const AdminSlotView({Key? key,required this.selectedDate}) : super(key: key);

  @override
  State<AdminSlotView> createState() => _AdminSlotViewState();
}

class _AdminSlotViewState extends State<AdminSlotView> {
  int columns = 2;
  int rows = 6;
  List<Map> plots = [];
  var slotList = [];
  List<int> booked=[];

  Future<Map<String, dynamic>> getSlotList(String selectedDate) async{
          final Map<String, dynamic> data = {
            "date":selectedDate
          };
        var res = await http.post(
        Uri.parse('http://'+serverIP+'/userandslotdetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },body: jsonEncode(data));
        
       return {"code": res.statusCode,"body":res.body};
    
  }

    Future<void> freeSlot(int id) async{
            final Map<String, dynamic> data = {
            "id":id,
          };
          //print(userid);
         var res = await http.post(
        Uri.parse('http://'+serverIP+'/userdeleteslot'),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text(
          "PARKit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.of(context).pop(),),
        ),
        body: slotList==null?CircularProgressIndicator():ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          children: List<Widget>.generate(
              slotList.length,
              (index) => Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.tag,
                                      size: 16.0,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                     Text("SLOT "+slotList[index][3].toString()),
                                  ],
                                ),
                           Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle_sharp,
                                      size: 16.0,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                     Text(slotList[index][0]+'  '+slotList[index][1]),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16.0,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                     Text('Time : '+slotList[index][4]+' - '+slotList[index][5]),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const VerticalDivider(
                                  width: 20,
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                IconButton.filledTonal(
                                  onPressed: () {
                                      setState(() {
                                        freeSlot(slotList[index][2]);
                                      });
                                  },
                                  icon: const Icon(Icons.close),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              growable: false),
        ),
      ),
    );
  }
}
