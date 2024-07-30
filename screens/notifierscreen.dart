import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:medhack/screens/chatscreen.dart';
import 'package:medhack/screens/imagepickpage.dart';
import 'package:medhack/Notificationservice.dart';

class Notifierscreen extends StatefulWidget {
  const Notifierscreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<Notifierscreen> createState() => _NotifierscreenState();
}

class _NotifierscreenState extends State<Notifierscreen> {
  int _selectedIndex = 0;
  late DateTime scheduletime = DateTime.now();
  List<Map<String, dynamic>> notifications = [];
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    NotificationService().initNotification();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pu(_selectedIndex);
    });
  }

  void pu(int index) {
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Notifierscreen(
                    selectedIndex: 0,
                  )));
    }
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Imagepickpage(
                    selectedIndex: 1,
                  )));
    }
    if (index == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ChatScreen(
                    selectedIndex: 2,
                  )));
    }
  }

  void _testNotification() {
    final DateTime now = DateTime.now();
    // ignore: unused_local_variable
    final DateTime scheduledTime =
        now.add(Duration(seconds: 5)); // 5 seconds later

    NotificationService().showNotification(
      title: 'Test Notification',
      body: 'This is a test notification.',
    );
  }

  void _addNotification() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a medicine name.')),
      );
      return;
    }

    if (scheduletime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a future date and time.')),
      );
      return;
    }

    setState(() {
      notifications.add({
        'title': _titleController.text,
        'time': scheduletime,
        'isScheduled': false,
      });

      // Schedule the notification
      NotificationService().scheduleNotification(
        title: 'Medicine Reminder',
        body: 'Time to take your medicine: ${_titleController.text}',
        scheduledNotificationDateTime: scheduletime,
      );

      _titleController.clear();
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications
          .removeAt(index); // Remove the notification at the specified index
    });
  }

  void _toggleSchedule(int index) {
    setState(() {
      notifications[index]['isScheduled'] =
          !notifications[index]['isScheduled'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: Color.fromRGBO(34, 96, 255, 0.9),
              fontWeight: FontWeight.w600,
              fontSize: 23),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Medicine Name')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Delete')),
                    ],
                    rows: notifications.asMap().entries.map(
                      (entry) {
                        int index = entry.key;
                        var notification = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(notification['title']!)),
                            DataCell(IconButton(
                              icon: Icon(notification['isScheduled']
                                  ? Icons.alarm_off
                                  : Icons.alarm_on),
                              onPressed: () => _toggleSchedule(index),
                            )),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteNotification(
                                    index), // Call delete method
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Medicine Name',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      dt_picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        theme: dt_picker.DatePickerTheme(
                          backgroundColor: Colors.blueGrey,
                          itemStyle: TextStyle(color: Colors.white),
                          cancelStyle: TextStyle(color: Colors.red),
                        ),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          setState(() {
                            scheduletime = date;
                          });
                        },
                        currentTime: DateTime.now(),
                      );
                    },
                    child: const Text('Add Timer'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addNotification();
                      // NotificationService().showNotification(
                      //     title: 'Notification', body: 'This is testing');
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Notifier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            label: 'Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_outlined),
            label: 'AskMe',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(34, 96, 255, 0.9),
        onTap: _onItemTapped,
      ),
    );
  }
}
