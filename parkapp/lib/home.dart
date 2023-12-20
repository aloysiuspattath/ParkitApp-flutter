import 'package:flutter/material.dart';
import 'package:parkapp/delete_slot.dart';
import 'date_selection.dart'; // Import the date selection page

class Homepage extends StatelessWidget {
  final String userid;
  const Homepage({Key? key, required this.userid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ParkIt App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    // HomePage.fromBase64(loginResp["token"])
                                    DateSelectionPage(userid: userid,)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBC0063),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(250, 50),
              ),
              child: const Text(
                'Book a Slot',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    // HomePage.fromBase64(loginResp["token"])
                                    DeleteDateSelection(userid:userid)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBC0063),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(250, 50),
              ),
              child: const Text(
                'Delete a Booked Slot',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
