import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({ super.key });

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  @override



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

 final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar:  AppBar(
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
              
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'First Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Last Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // You can add more sophisticated email validation if needed
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Phone',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            else if(value.length!=10){
                               return 'Must Contain 10 digits';
                            }
                            // You can add more phone number validation if needed
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _userIdController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'User ID',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your user ID';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            // You can add more password validation if needed
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Perform sign-up logic here
                              // For example, you can print the values to the console
                              var fname=_firstNameController.text;
                                var lname=_lastNameController.text;
                            var cont=_phoneController.text;
                            var email=_emailController.text;
                            var uid=_userIdController.text;
                            var pwd=_passwordController.text;
      
                             var resp = await attemptSignUp(fname,lname,cont,email,uid,pwd);
                             var signResp = json.decode(resp["body"]);
                            if(resp['code']==200){
                                    if(signResp['task']=="Userid exists"){
                                      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('User ID Already Taken'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
                              }
                              else{
                                 ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Success'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
              Navigator.of(context).pop();
                              }
                                print(signResp['task']);
                                
                            }
                            else{
                          
                              print("Error");
                            }
                              // print('First Name: ${_firstNameController.text}');
                              // print('Last Name: ${_lastNameController.text}');
                              // print('Email: ${_emailController.text}');
                              // print('Phone: ${_phoneController.text}');
                              // print('User ID: ${_userIdController.text}');
                              // For security reasons, don't print the password
                              // Instead, you would typically send it to a server for authentication
                              // print('Password: ${_passwordController.text}');
                            }
                          },
                          child: Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
