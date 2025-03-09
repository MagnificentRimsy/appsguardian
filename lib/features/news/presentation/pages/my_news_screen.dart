import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import the package

import '../providers/news_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/news_card.dart';

class MyNewsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsListNotifierProvider);

    return Column(
      children: [
        CustomSearchBar(),
        Expanded(
          child: newsState.when(
            data: (newsList) {
              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return NewsCard(
                    imageUrl: news.images.isNotEmpty ? news.images[0] : '',
                    title: news.title,
                    description: news.contents,
                    date: DateFormat.yMMMEd().format(news.date),
                    source: news.source,
                    onDelete: () {
                      ref.read(newsListNotifierProvider.notifier).removeNews(index);
                      ref.read(newsListNotifierProvider.notifier).loadNewsArticles();
                    },
                  );
                },
              );
            },
            loading: () => Center(
              child: LoadingAnimationWidget.flickr(
                size: 50,
                leftDotColor: Colors.red,
                rightDotColor: Colors.black87,
              ),
            ),
            error: (error, stack) => Center(
              child: Text('Something went wrong: $error'),
            ),
          ),
        ),
      ],
    );
  }
}
