import 'package:flutter/material.dart';
import 'package:iti_news_app/models/article_model.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key, required this.news});
  final ArticleModel news;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'News Detail',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(25),
                child: Image.network(
                  // fit: BoxFit.fill,
                  news.image ??
                      'https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg',
                ),
              ),
              SizedBox(height: 10),

              Text(
                news.author ?? 'No Author',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 30),
              Text(
                news.title ?? 'No Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              Text(
                news.disc ?? 'No',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff322933),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
