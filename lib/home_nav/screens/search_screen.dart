import 'package:flutter/material.dart';
import 'package:iti_news_app/widgets/search_row.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            SearchRow(searchController: searchController),
          ],
        ),
      ),
    );
  }
}


