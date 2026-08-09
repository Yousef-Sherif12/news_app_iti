import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_news_app/home_nav/cubit/home_cubit/home_cubit.dart';
import 'package:iti_news_app/home_nav/cubit/home_cubit/home_state.dart';
import 'package:iti_news_app/news_details/news_details_screen.dart';
import 'package:iti_news_app/widgets/search_result_item.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key, required this.searchController});
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getSearchNews(q: searchController.text),
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Color(0xff231F20)),
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Search results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xff231F20),
            ),
          ),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is HomeFailure) {
              return Text('No Data!');
            }
            if (state is HomeSuccess) {
              return ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailsScreen(news: state.articles[index]),
                      ),
                    ),
                    child: SearchResultItem(
                      newImage: state.articles[index].image ?? '',
                      title: state.articles[index].title ?? '',
                      subTitle: state.articles[index].disc ?? '',
                      date: state.articles[index].publishedAt ?? '',
                    ),
                  );
                },
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
