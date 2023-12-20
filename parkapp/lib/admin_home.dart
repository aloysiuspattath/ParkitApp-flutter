import "package:flutter/material.dart";
import 'package:parkapp/admin_date.dart';
import 'dart:developer';
import 'package:parkapp/components/menu_item.dart';
import 'package:parkapp/view_users.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text(
          "PARKit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.of(context).pop(),),
        ),
        body:  Column(
          children: [
            SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: CategoriesCard(
            text:" Users",
            icon: Icons.account_circle,
             // onPressed: () => {},
            ),
            onTap: (){
                                     Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    // HomePage.fromBase64(loginResp["token"])
                                    ViewUsers()));
            },
          ),
          SizedBox(width: 15),
          GestureDetector(
             onTap: (){
                                     Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    // HomePage.fromBase64(loginResp["token"])
                                    AdminDateSelectionPage()));
            },
            child: CategoriesCard(
              text:" Slot",
              icon: Icons.drive_eta_sharp,
            ),
          ),
        ],
      ),
    )
          ],
        ),
      ),
    );
  }
}
