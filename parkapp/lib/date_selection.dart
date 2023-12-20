// date_selection.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkapp/book_slot.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSelectionPage extends StatefulWidget {
  final String userid;
  const DateSelectionPage({Key? key, required this.userid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DateSelectionPageState createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

   DateTime? _startTime;
  DateTime? _endTime;

  Future<void> _selectStartTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _startTime == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              DateTime(0, 0, 0, _startTime!.hour, _startTime!.minute)),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        _startTime = selectedDateTime;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _endTime == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(
              DateTime(0, 0, 0, _endTime!.hour, _endTime!.minute)),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        _endTime = selectedDateTime;
      });
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Start Time',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF0F0F0),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: TextButton(
                              onPressed: _selectStartTime,
                              child: Text(
                                _startTime == null
                                    ? 'Select Time'
                                    : DateFormat.jm().format(_startTime!),
                                style: TextStyle(
                                  color: _startTime == null
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'End Time',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF0F0F0),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: TextButton(
                              onPressed: _selectEndTime,
                              child: Text(
                                _endTime == null
                                    ? 'Select Time'
                                    : DateFormat.jm().format(_endTime!),
                                style: TextStyle(
                                  color: _endTime == null
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Proceed to book a slot only if a date is selected
                  if (_selectedDay != null && _startTime!=null && _endTime!=null && _startTime!.isBefore(_endTime!)) {
                    
                    var startTime= '${(_startTime!.hour)}:${(_startTime!.minute)}';
                    var endTime='${(_endTime!.hour)}:${(_endTime!.minute)}';
                    print(startTime);
                    print(endTime);

                    var formattedDate = "${_selectedDay?.year}-${_selectedDay?.month}-${_selectedDay?.day}";
                    print(formattedDate);
                       Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                    // HomePage.fromBase64(loginResp["token"])
                                    BookSlotPage(userid: widget.userid,selectedDate: formattedDate,startTime: startTime,endTime: endTime,)));
                  }
                  else if(_startTime!.isAfter(_endTime!)){
                       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('End Time is before Start Time'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
                  }
          //         else if( _startTime!.isBefore(DateTime.now()) || _endTime!.isBefore(DateTime.now())){
          //           ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: const Text('Invalid Time Selection'),
          //     action: SnackBarAction(
          //       label: 'OK',
          //       onPressed: () {
          //         // Code to execute.
          //       },
          //     ),
          //   ),
          // );
          //         }
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
                  'Proceed to Book a Slot',
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
