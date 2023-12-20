import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:parkapp/main.dart';

class UserSlotDeletion extends StatefulWidget {
  final String userid;
  final String date;
  const UserSlotDeletion({Key? key, required this.userid,required this.date}) : super(key: key);

  @override
  State<UserSlotDeletion> createState() => _UserSlotDeletionState();
}

class _UserSlotDeletionState extends State<UserSlotDeletion> {


var slotList;
var booked=[];
  Future<Map<String, dynamic>> getSlotList(String selectedDate) async{
          final Map<String, dynamic> data = {
            "date":selectedDate,
            "userid":widget.userid
          };
        var res = await http.post(
        Uri.parse('http://'+serverIP+'/userslotlist'),
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
        
         getSlotList(widget.date)
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

        getSlotList(widget.date)
        .then((resp) => setState(() {
           
              var response=json.decode(resp["body"]);
              slotList=response['data'];
              print(slotList);
              for(int i=0;i<slotList.length;i++){
                booked.add(slotList[i][0]);
                print(slotList[i][0]);
              }
              
            }))
        .catchError((error) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        appBar:  AppBar(
        title: const Text(
          "PARKit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
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
                                     Text("SLOT "+slotList[index][1].toString()),
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
                                     Text('Time : '+slotList[index][5]+' - '+slotList[index][6]),
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
                                        freeSlot(slotList[index][0]);
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