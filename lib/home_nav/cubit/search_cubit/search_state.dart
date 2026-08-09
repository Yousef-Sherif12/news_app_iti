import 'package:iti_news_app/models/article_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<ArticleModel> searchResultList;
  SearchSuccess({required this.searchResultList});
}

class SearchFailure extends SearchState {
  final String message;
  SearchFailure({required this.message});
}
