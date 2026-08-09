import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({
    super.key,
    required this.newImage,
    required this.title,
    required this.subTitle,
    required this.date,
  });
  final String newImage;
  final String title;
  final String subTitle;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 5,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5),
                Text(
                  subTitle,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffD2B0B0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 20),

          Image.network(
            newImage,
            fit: BoxFit.fill,
            width: 150,
            height: 110,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 150);
            },
          ),
        ],
      ),
    );
  }
}
