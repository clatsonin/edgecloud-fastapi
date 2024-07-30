import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:medhack/serper.dart';

class ProductsPage extends StatefulWidget {
  final String medicinename;

  ProductsPage({
    Key? key,
    required this.medicinename,
  }) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> _productList = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    Serper serper = Serper();
    List<Map<String, dynamic>> products = await serper.serpercall(
      widget.medicinename,
    );
    setState(() {
      _productList = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          size: 30,
        ),
        title: const Text(
          "Purchase",
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: _productList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSwiperCards(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwiperCards() {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return _buildCard(_productList[index]);
      },
      itemCount: _productList.length,
      layout: SwiperLayout.STACK,
      itemWidth: MediaQuery.of(context).size.width - 2 * 40,
      itemHeight: MediaQuery.of(context).size.height * 0.7,
      curve: Curves.easeOutCubic,
      onIndexChanged: (index) {
        setState(() {
          // Handle card index change if needed
        });
      },
      onTap: (index) {
        // Handle card tap if needed
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  product['imageUrl'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  alignment: AlignmentDirectional.topStart,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      product['title'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      'Price: ${product['price']}',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(context, product['link']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(34, 96, 255, 0.9),
                      ),
                      child: const Text(
                        'View Product',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    if (await launchUrl(uri)) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
