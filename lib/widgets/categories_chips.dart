import 'dart:developer';

import 'package:flutter/material.dart';

class CategoriesChips extends StatefulWidget {
  const CategoriesChips({super.key, required this.onChangeCategory});
  final Function(String category) onChangeCategory;
  @override
  State<CategoriesChips> createState() => CategoriesChipsState();
}

class CategoriesChipsState extends State<CategoriesChips> {
  final List<String> categories = ["All", "Politic", "Sport", "Education"];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(categories.length, (index) {
        final bool isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: ChoiceChip(
            label: Text(
              categories[index],
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: Color(0xffFFA500),
            disabledColor: Color(0xffFFFFFF),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: !isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),

            onSelected: (_) {
              setState(() {
                selectedIndex = index;
              });
              log('CATEGORY: ${categories[index]}');

              widget.onChangeCategory(categories[index]);
            },
          ),
        );
      }),
    );
  }
}
