import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_news_app/home_nav/cubit/home_cubit/home_cubit.dart';
import 'package:iti_news_app/home_nav/cubit/home_cubit/home_state.dart';
import 'package:iti_news_app/news_details/news_details_screen.dart';
import 'package:iti_news_app/widgets/categories_chips.dart';
import 'package:iti_news_app/widgets/new_item.dart';
import 'package:iti_news_app/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSearchTap});
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getData(),

      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Color(0xffFAF9F9),
            drawer: Drawer(),
            appBar: AppBar(
              backgroundColor: Color(0xffFAF9F9),
              elevation: 0,
              scrolledUnderElevation: 0,
              actions: [
                InkWell(
                  onTap: onSearchTap,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.search, color: Colors.black, size: 28),
                  ),
                ),
                SizedBox(width: 9),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // SectionHeader(text1: 'Breaking News', text2: 'Show More'),
                // SizedBox(height: 5),
                // Image.asset('assets/images/new_image.png'),
                SizedBox(height: 10),
                CategoriesChips(
                  onChangeCategory: (category) {
                    final cubit = context.read<HomeCubit>();
                    if (category == 'All') {
                      cubit.getData();
                    } else {
                      cubit.getSearchNews(q: category);
                    }
                  },
                ),
                SizedBox(height: 15),
                SectionHeader(text1: 'News For You', text2: 'Show More'),
                SizedBox(height: 10),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                          backgroundColor: Colors.amberAccent,
                        ),
                      );
                    }
                    if (state is HomeFailure) {
                      return Text('NO DATA');
                    }
                    if (state is HomeSuccess) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.articles.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailsScreen(
                                    news: state.articles[index],
                                  ),
                                ),
                              ),
                              child: NewItem(
                                newImage:
                                    state.articles[index].image ??
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIQxNvVNHiyeHRcD7sYkuIupkwKjwAsl1gEKxtr_hV7frdAdLxzsXGrkeQ&s=10',
                                title: state.articles[index].title ?? '',
                                subTitle: state.articles[index].disc ?? '',
                                date: state.articles[index].publishedAt ?? '',
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
