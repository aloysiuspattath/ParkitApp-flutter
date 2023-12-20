import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'main.dart';

import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController _fname=TextEditingController();
    final TextEditingController _lname=TextEditingController();
    final TextEditingController _cont=TextEditingController();
    final TextEditingController _email=TextEditingController();
    final TextEditingController _userid=TextEditingController();
    final TextEditingController _passwd=TextEditingController();

    Future<Map<String, dynamic>> attemptSignUp(String fname,String lname,String cont,String email,String uid,String password) async{
          final Map<String, dynamic> data = {
            "fname":fname,
            "lname":lname,
            "contact":cont,
            "email":email,
            "userid":uid,
            "password":password
          };
    
        var res = await http.post(
        Uri.parse('http://'+serverIP+'/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(data));
       return {"code": res.statusCode,"body":res.body};
    
  }
   

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("PARKit"),
        leading: BackButton(onPressed: () => Navigator.of(context).pop(),),
        ),
         body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                  //   child: FlutterLogo(
                  //     size: 40,
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: _fname,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      
                      controller: _lname,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                      Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      
                      controller: _cont,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Contact No',
                      ),
                    ),
                  ),
                      Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      
                      controller: _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                      Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      
                      controller: _userid,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'ID',
                      ),
                    ),
                  ),
                      Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      obscureText: true,
                      controller: _passwd,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Sign Up'),
                        onPressed: ()  async {
                          var fname=_fname.text;
                          var lname=_lname.text;
                          var cont=_cont.text;
                          var email=_email.text;
                          var uid=_userid.text;
                          var pwd=_passwd.text;
                          var resp = await attemptSignUp(fname,lname,cont,email,uid,pwd);
                          if(resp['code']==200){
                              var signResp = json.decode(resp["body"]);
                              print(signResp['task']);
                          }
                          else{
                            print("Error");
                          }
                        },
                      )),
                    
                  // TextButton(
                  //   onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 // HomePage.fromBase64(loginResp["token"])
                  //                 SignUp()));
                  //   },
                  //   child: Text(
                  //     'Sign up',
                  //     style: TextStyle(color: Colors.grey[600]),
                  //   ),
                  // ),
                ],
              ),
            ),
      ),
    );
    
  }
}