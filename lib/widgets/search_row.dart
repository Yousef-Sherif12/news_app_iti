import 'package:flutter/material.dart';
import 'package:iti_news_app/widgets/custom_text_field.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: CustomTextField(searchController: searchController)),
        SizedBox(width: 12),
        InkWell(
          onTap: () {
            searchController.clear();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xff0E0AB1),
            ),
          ),
        ),
      ],
    );
  }
}
