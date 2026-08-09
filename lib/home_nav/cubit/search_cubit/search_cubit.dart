// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iti_news_app/home_nav/cubit/search_cubit/search_state.dart';
// import 'package:iti_news_app/models/article_model.dart';

// class SearchCubit extends Cubit<SearchState> {
//   SearchCubit() : super(SearchInitial());

//   final Dio dio = Dio();
//   Future getSearchNews({required String q}) async {
//     emit(SearchLoading());
//     try {
//       final Response response = await dio.get(
//         'https://newsapi.org/v2/everything',
//         queryParameters: {'q': q, 'apiKey': 'ef837bf249cc4c519629925877eec3d6'},
//       );
//       final article = response.data['articles'] as List;
//       final data = article.map((e) => ArticleModel.fromJson(e)).toList();
//       emit(SearchSuccess(searchResultList: data));
//     } on DioException catch (e) {
//       return SearchFailure(message: e.message ?? 'Failure');
//     } catch (e) {
//       return e.toString();
//     }
//   }
// }
