import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:last_nyam/component/home/category.dart';
import 'content_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Category(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContentDetail(),
                        ),
                      );
                    },
                    child: ContentCard(
                      title: '국내산 돼지고기',
                      discount: '10%',
                      price: '10,000원',
                      timeLeft: '11분',
                      imagePath: 'assets/image/pork_card.png',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContentDetail(),
                        ),
                      );
                    },
                    child: ContentCard(
                      title: '달콤매콤 시장 쌀 떡볶이',
                      discount: '34%',
                      price: '2,000원',
                      timeLeft: '3시간',
                      imagePath: 'assets/image/tteopokki_card.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final String title;
  final String discount;
  final String price;
  final String timeLeft;
  final String imagePath;

  const ContentCard({
    super.key,
    required this.title,
    required this.discount,
    required this.price,
    required this.timeLeft,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%로 설정
      constraints: const BoxConstraints(maxWidth: 350), // 최대 너비 350
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      discount,
                      style: const TextStyle(
                        color: Color(0xFF417C4E),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      timeLeft,
                      style: const TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}