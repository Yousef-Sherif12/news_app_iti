import 'package:flutter/material.dart';
import 'package:iti_news_app/home_nav/screens/search_results_screen.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 13),
        prefixIcon: Icon(Icons.search),
        hintText: 'Exp|',
        hintStyle: TextStyle(
          color: Color(0xff231F20),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Color(0xffF0EFF0),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xff577CD9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xff577CD9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xff577CD9)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xff577CD9)),
        ),
      ),
      onSubmitted: (value) {
        if (searchController.text.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SearchResultsScreen(searchController: searchController),
            ),
          ).then((value) {
            searchController.clear();
          });
        }
      },
    );
  }
}
