import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:medhack/screens/imagepickpage.dart';
import 'package:medhack/screens/notifierscreen.dart';

class GenicalBot extends StatefulWidget {
  const GenicalBot(
      {super.key,
      required this.selectedIndex,
      required this.medicinename,
      required this.medicalhistory});
  final int selectedIndex;
  final String medicinename;
  final String medicalhistory;

  @override
  State<GenicalBot> createState() => _GenicalBotState();
}

class _GenicalBotState extends State<GenicalBot> with WidgetsBindingObserver {
  List<Message> messages = [];
  bool isMicSelected = false;
  final TextEditingController _controller = TextEditingController();
  late int _selectedIndex;
  String response1 = '';
  String medicinename = '';
  String medicialhistory = '';
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    WidgetsBinding.instance.addObserver(this);
    medicinename = widget.medicinename;
    medicialhistory = widget.medicalhistory;
    messages.add(Message(
      content:
          "Genical bot is your personalized medical helper based on the medicine given and your past medical history. What's on your mind?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Ensure the correct tab is highlighted when app resumes
      setState(() {
        _selectedIndex = 2;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Don't navigate if we're already on the selected page
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    _navigateToSelectedPage(index);
  }

  void _navigateToSelectedPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Notifierscreen(selectedIndex: 0),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Imagepickpage(selectedIndex: 1),
          ),
        );
        break;
      case 2:
        // No navigation needed if already on GenicalBot
        break;
    }
  }

  Future<void> getGeminiResponse(String question) async {
    const apiKey = 'AIzaSyDB_K7Vyp8rOmgwxFAJ_GhToeXfTl4vDdc';

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final prompt =
          "just give straight answer to the question: $question and answer by referring to the medicine name $medicinename and the patient has the medical problem $medicialhistory and the previous chat response is $response1";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final answer =
          response.text ?? 'No response from API'; // Handle null case
      setState(() {
        messages.add(Message(content: answer, isUser: false));
        response1 = answer;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        messages.add(Message(content: 'Error: $e', isUser: false));
      });
    }
  }

  void toggleIcon(int index) {
    setState(() {
      _selectedIndex = _selectedIndex == index ? -1 : index;
      if (_selectedIndex == 1) {
        messages.clear();
        messages.add(Message(
            content: 'Type your question and press send.', isUser: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ask anything to Genical",
          style: TextStyle(
            color: Color.fromRGBO(34, 96, 255, 0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color.fromRGBO(34, 96, 255, 0.9),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                Message message = messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? const Color.fromRGBO(34, 96, 255, 0.9)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!isMicSelected)
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your question here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String question = _controller.text;
                      if (question.isNotEmpty) {
                        setState(() {
                          messages
                              .add(Message(content: question, isUser: true));
                        });
                        getGeminiResponse(question);
                        _controller.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                    color: const Color.fromRGBO(34, 96, 255, 0.9),
                  ),
                ],
              ),
            ),
        ],
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
        selectedItemColor: Color.fromRGBO(34, 96, 255, 0.9),
        onTap: _onItemTapped,
      ),
    );
  }
}

class ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const ToggleIconButton({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: isSelected ? const Color.fromRGBO(34, 96, 255, 0.9) : Colors.grey,
      onPressed: onPressed,
      iconSize: 36,
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}
