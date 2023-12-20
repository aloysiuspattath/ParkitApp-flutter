import 'dart:convert';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class ViewUsers extends StatefulWidget {
  
  const ViewUsers({super.key});
  
  
 

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
    
var userList;



   Future<Map<String, dynamic>> getUsersList() async{
      
        var res = await http.post(
        Uri.parse('http://'+serverIP+'/viewusers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });
        
       return {"code": res.statusCode,"body":res.body};
    
  }

  Future<void> deleteUser(String userid) async{
            final Map<String, dynamic> data = {
            "userid":userid,
          };
          print(userid);
         var res = await http.post(
        Uri.parse('http://'+serverIP+'/deleteuser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },body: jsonEncode(data)
        );
        setState(() {
             getUsersList()
        .then((resp) => setState(() {
              var response=json.decode(resp["body"]);
              userList=response['data'];
            }))
        .catchError((error) => setState(() {}));
        });
  }

 @override
  void initState() {
    //debugPrint("hello " + _member.memberType!.memberTypeCode.toString());
    // _fetchingData = true;
    getUsersList()
        .then((resp) => setState(() {
              var response=json.decode(resp["body"]);
              userList=response['data'];
            }))
        .catchError((error) => setState(() {}));
    // _fetchingData = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar:  AppBar(
        title: const Text(
          "PARKit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
      ),
        body: userList==null?CircularProgressIndicator():ListView.builder(itemBuilder: (context,index){
            return ListTile(
              leading: IconButton(onPressed: (){}, icon: Icon(Icons.account_circle_sharp)),
              title: Text(userList[index][0]+" "+userList[index][1]),
              subtitle: Text(userList[index][2]),
              trailing: IconButton(onPressed: (){
                var uid=userList[index][4];
                
                setState(() {
                  deleteUser(uid);
                });
              }, icon: Icon(Icons.close_outlined))
            );
        },
        itemCount: userList.length)
        
        ),
      );
    
  }
}