import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medhack/fastapi.dart';
import 'package:medhack/screens/chatscreen.dart';
import 'package:medhack/screens/genicalbot.dart';
import 'package:medhack/screens/notifierscreen.dart';
import 'package:medhack/screens/productscreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:medhack/screens/imagepickpage.dart';

class Infopage extends StatefulWidget {
  final XFile xfilePick;
  final Future<String> responseText;
  final int selectedIndex;
  final String history;

  const Infopage(
      {super.key,
      required this.xfilePick,
      required this.responseText,
      required this.selectedIndex,
      required this.history});

  @override
  State<Infopage> createState() => _InfopageState();
}

class _InfopageState extends State<Infopage> {
  late Future<List<Map<String, dynamic>>> _medicalinfo;
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _medicalinfo = fetchinfo();
  }

  Future<List<Map<String, dynamic>>> fetchinfo() async {
    return await Fastapi.game1(widget.responseText);
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
              builder: (context) => Notifierscreen(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          size: 30,
        ),
        title: const Text(
          "Your Medicine",
          style: TextStyle(
            color: Color.fromRGBO(34, 96, 255, 0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _medicalinfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            } else {
              return _buildContent(snapshot.data!);
            }
          },
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
        selectedItemColor: Color.fromRGBO(34, 96, 255, 0.9),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Grid for the buttons
            Row(
              children: [
                _buildShimmerGridButton(),
                const SizedBox(width: 10),
                _buildShimmerGridButton(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildShimmerGridButton(),
                const SizedBox(width: 10),
                _buildShimmerGridButton(),
              ],
            ),
            const SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGridButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.445,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _buildContent(List<Map<String, dynamic>> medicalinfo) {
    final medicineInfo = medicalinfo.first;
    final medicineName = medicineInfo['medicine_name'] ?? 'Unknown Medicine';
    final chemicalFormula =
        medicineInfo['chemical_formula'] ?? 'Unknown Formula';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.indigo[100],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File(widget.xfilePick.path)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset('assets/logo.png'),
                                  ),
                                  const Text(
                                    'Genical Search',
                                    style: TextStyle(
                                        color: Color.fromRGBO(34, 96, 255, 0.9),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  medicineName,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Chemical formula : $chemicalFormula',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Grid for the buttons
            Row(
              children: [
                _buildGridButton(
                    context, 'ABOUT', Icons.chat_bubble, medicineInfo),
                const SizedBox(width: 10),
                _buildGridButton(
                    context, 'SIDE-EFFECTS', Icons.warning, medicineInfo),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildGridButton(context, 'GENICAL BOT', Icons.ac_unit_outlined,
                    medicineInfo),
                const SizedBox(width: 10),
                _buildGridButton(
                    context, 'DOSAGE', Icons.medical_services, medicineInfo),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsPage(
                                medicinename: medicineName,
                              )));
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.shopping_cart_rounded, color: Colors.black),
                        Icon(
                          Icons.arrow_outward_outlined,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('PURCHASE NOW',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String text, IconData icon,
      Map<String, dynamic> medicineInfo) {
    final ABOUT =
        medicineInfo['medicine_information'] ?? 'No information available';

    final DOSAGE = medicineInfo['dosage'] ?? 'No information available';
    final side_effects =
        medicineInfo['precautions'] ?? 'No information available';
    final medicinename =
        medicineInfo['medicine_name'] ?? 'No information available';

    return SingleChildScrollView(
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.43,
        width: MediaQuery.of(context).size.width * 0.445,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
          ),
          onPressed: () {
            switch (text) {
              case "ABOUT":
                _showMyDialog(ABOUT, 'ABOUT');
                break;

              case "GENICAL BOT":
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenicalBot(
                              selectedIndex: 2,
                              medicalhistory: widget.history,
                              medicinename: medicinename,
                            )));
                break;
              case "DOSAGE":
                _showMyDialog(DOSAGE, 'DOSAGE');
                break;
              case "SIDE-EFFECTS":
                _showMyDialog(side_effects, 'SIDE-EFFECTS');
                break;

              default:
                break;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: Colors.black),
                  const Icon(
                    Icons.arrow_outward_outlined,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(final output, final box) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(box),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(output),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
