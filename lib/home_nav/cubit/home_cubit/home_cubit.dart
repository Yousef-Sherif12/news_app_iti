import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_news_app/home_nav/cubit/home_cubit/home_state.dart';
import 'package:iti_news_app/models/article_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final dio = Dio();
  Future getData() async {
    try {
      emit(HomeLoading());
      final Response response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': 'ef837bf249cc4c519629925877eec3d6',
        },
      );

      final article = response.data['articles'] as List;
      final data = article.map((e) => ArticleModel.fromJson(e)).toList();

      emit(HomeSuccess(data));
    } on DioException catch (e) {
      emit(HomeFailure(e.message ?? 'FAILURE'));
    } catch (e) {
      HomeFailure(e.toString());
    }
  }

  Future getSearchNews({required String q}) async {
    emit(HomeLoading());
    try {
      final Response response = await dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {'q': q, 'apiKey': 'ef837bf249cc4c519629925877eec3d6'},
      );
      final article = response.data['articles'] as List;
      final data = article.map((e) => ArticleModel.fromJson(e)).toList();
      emit(HomeSuccess(data));
    } on DioException catch (e) {
      return HomeFailure(e.message ?? 'Failure');
    } catch (e) {
      return e.toString();
    }
  }
}
