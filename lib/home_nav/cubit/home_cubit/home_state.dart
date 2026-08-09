import 'package:iti_news_app/models/article_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ArticleModel> articles;

  HomeSuccess(this.articles);
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
