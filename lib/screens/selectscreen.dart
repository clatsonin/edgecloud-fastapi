import 'package:flutter/material.dart';
import 'package:medhack/screens/chatscreen.dart';
import 'package:medhack/screens/imagepickpage.dart';
import 'package:medhack/screens/notifierscreen.dart';

class Selectscreen extends StatefulWidget {
  const Selectscreen({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<Selectscreen> createState() => _SelectscreenState();
}

class _SelectscreenState extends State<Selectscreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pu(_selectedIndex);
    });
  }

  void pu(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Notifierscreen(selectedIndex: 0),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Imagepickpage(selectedIndex: 1),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(selectedIndex: 2),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Genical',
          style: TextStyle(
              color: Color.fromRGBO(34, 96, 255, 0.9),
              fontWeight: FontWeight.w600,
              fontSize: 23),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 400,
                height: 400,
              ),
              const Text(
                "Hi, How may we help you today?",
                style: TextStyle(
                  color: Color.fromRGBO(34, 96, 255, 0.9),
                ),
              )
            ],
          ),
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
        currentIndex: _selectedIndex, // Valid index

        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
