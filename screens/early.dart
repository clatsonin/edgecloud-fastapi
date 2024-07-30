import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medhack/screens/infopage.dart';

class Early extends StatefulWidget {
  const Early({
    super.key,
    required this.xfilePick,
    required this.responseText,
    required this.selectedIndex,
  });

  final XFile xfilePick;
  final Future<String> responseText;
  final int selectedIndex;

  @override
  State<Early> createState() => _EarlyState();
}

class _EarlyState extends State<Early> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _controller1;
  late Animation<double> _animation1;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // Initialize animation controllers
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation1 = CurvedAnimation(
      parent: _controller1,
      curve: Curves.decelerate,
    );

    _controller1.forward();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose animation controllers
    _controller1.dispose();
    _controller.dispose();
    _textEditingController.dispose();
    super.dispose();
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
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/white.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Use SingleChildScrollView to allow scrolling of content
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    opacity: _animation1,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: const Offset(0, 0),
                      ).animate(_animation1),
                      child: Container(
                        // Adjust the height dynamically based on screen size
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(34, 96, 255, 0.9),
                          borderRadius: BorderRadiusDirectional.vertical(
                            top: Radius.elliptical(360, 190),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _animation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const RadialGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.transparent
                                        ],
                                        stops: [0.5, 1],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.6),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                        'assets/logo.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 50), // Reduced spacing
                            const Text(
                              'Do you have any past medical histories? If yes, please let us know!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20), // Reduced spacing
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _textEditingController,
                              autocorrect: true,
                              expands: false,
                              decoration: InputDecoration(
                                hintText: 'eg. Asthma, Diabetes etc.',
                                hintStyle:
                                    const TextStyle(color: Colors.white70),
                                counterStyle:
                                    const TextStyle(color: Colors.white),
                                filled: false,
                                fillColor: Colors.grey[400],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20), // Reduced spacing
                            ElevatedButton(
                              onPressed: () {
                                String history = _textEditingController.text;
                                if (history.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Infopage(
                                        xfilePick: widget.xfilePick,
                                        responseText: widget.responseText,
                                        selectedIndex: widget.selectedIndex,
                                        history: history,
                                      ),
                                    ),
                                  );
                                  _textEditingController.clear();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Let\'s go Genical ✨',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
