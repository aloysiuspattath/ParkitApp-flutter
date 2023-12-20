// date_selection.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkapp/admin_slot.dart';
import 'package:parkapp/book_slot.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminDateSelectionPage extends StatefulWidget {
  const AdminDateSelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminDateSelectionPageState createState() => _AdminDateSelectionPageState();
}

class _AdminDateSelectionPageState extends State<AdminDateSelectionPage> {
  
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select a Date",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFBC0063),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Light off-white background color
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  border: Border.all(color: Colors.grey[300]!), // Border
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Proceed to book a slot only if a date is selected
                  if (_selectedDay != null) {
                    
                    
                    var formattedDate = "${_selectedDay?.year}-${_selectedDay?.month}-${_selectedDay?.day}";
                    print(formattedDate);
                       Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    // HomePage.fromBase64(loginResp["token"])
                                    AdminSlotView(selectedDate: formattedDate,)));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedDay != null
                      ? const Color(0xFFBC0063)
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
