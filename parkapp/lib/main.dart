import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkapp/admin_home.dart';
import 'package:parkapp/home.dart';
import 'package:parkapp/owner.dart';
import 'package:parkapp/owner_date.dart';
import 'package:parkapp/signup.dart';
import 'package:http/http.dart' as http;
import 'package:parkapp/user_signup.dart';

const serverIP='192.168.158.92:5000';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PARKit',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
  final TextEditingController _userid=TextEditingController();
  final TextEditingController _passwd=TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _loginIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

   Future<Map<String, dynamic>> attemptLogIn(String username, String password) async{
          final Map<String, dynamic> data = {
            "username":username,
            "password":password
          };
    
        var res = await http.post(
        Uri.parse('http://'+serverIP+'/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(data));
       return {"code": res.statusCode,"body":res.body};
    
  }

  
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Scaffold(
            appBar: AppBar(
        title: const Text(
          "PARKit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
      ),
             body: SingleChildScrollView(
               child: Center(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Image.asset(
                'assets/logo.png', // Adjust the path based on your asset location
                width: 200.0, // Adjust the width as needed
                height: 250.0, // Adjust the height as needed
                         ),
                     Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Form(
                             key: _formKey,
                             child: Column(
                               children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _loginIdController,
                          decoration:  InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                          ),
                          labelText: 'User ID',
                        ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your User ID';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration:  InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                          ),
                          labelText: 'Password',
                        ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            var userid=_loginIdController.text;
                            var passwd=_passwordController.text;
                            // Validate the form
                            if (_formKey.currentState?.validate() == true) {
                              // Form is valid, perform login or other actions
                              
             
                                 var resp = await attemptLogIn(userid, passwd);
                            if(resp['code']==200){
                                print("success");
                                var loginResp = json.decode(resp["body"]);
             
                                if(loginResp['status']=='T'){
                                  print("user exists");
                                  if(loginResp['type']=='cust'){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) =>
                                      // HomePage.fromBase64(loginResp["token"])
                                      Homepage(userid: userid,)));
                                  }
                                   else if(loginResp['type']=='admin'){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) =>
                                      // HomePage.fromBase64(loginResp["token"])
                                      AdminHome()));
                                  }
                                    else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) =>
                                      // HomePage.fromBase64(loginResp["token"])
                                      OwnerDateSelection()));
                                  }
                                }
                                else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                content: const Text('Invalid Credentials'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Code to execute.
                  },
                ),
                         ),
                       );
                                }
                            }
                            else{
                              print("error");
                            }
                            }
                          },
                          child: Text('Login'),
                        ),
                      ),
                               ],
                             ),
                           ),
                         ),
                         TextButton(onPressed: (){
                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) =>
                                      // HomePage.fromBase64(loginResp["token"])
                                      UserSignUp()));
                         }, child: Text("Sign Up"))
                   ],
                 ),
               ),
             ),
    );
  }
}
