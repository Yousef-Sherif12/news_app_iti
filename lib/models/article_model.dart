
class ArticleModel {
  String? author;
  String? title;
  String? disc;
  String? image;
  String? publishedAt;
  ArticleModel({
    this.author,
    this.disc,
    this.image,
    this.publishedAt,
    this.title,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> date) {
    return ArticleModel(
      author: date['author'],
      disc: date['description'],
      image: date['urlToImage'],
      publishedAt: date['publishedAt'],
      title: date['title'],
    );
  }
}
