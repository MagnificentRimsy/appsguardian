import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../providers/news_provider.dart';
import 'add_news_screen.dart';
import 'my_news_screen.dart';

class MainScreen extends ConsumerWidget {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  String profilPic = "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=60&w=500";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the state of the news provider
    final newsState = ref.watch(newsListNotifierProvider);

    // Triggering the loadNewsArticles method to fetch news
    ref.watch(newsListNotifierProvider.notifier).loadNewsArticles();

    _pageController.addListener(() {
      _currentPage.value = _pageController.page!.round();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Fabrice 👋',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Reading News Today?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                profilPic,
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger refresh
          await ref.read(newsListNotifierProvider.notifier).loadNewsArticles();
        },
        child: newsState.when(
          data: (news) {
            // Your list of news articles
            return PageView(
              controller: _pageController,
              children: [
                MyNewsScreen(),
                AddNewsScreen(),
                const Text("Trending"),
              ],
            );
          },
          loading: () {
            // Custom preload indicator while loading
            return Center(child: Center(
              child: LoadingAnimationWidget.flickr(
                  size: 50,
                  leftDotColor: Colors.red,
                  rightDotColor: Colors.black87
              ),
            ));
          },
          error: (error, stack) {
            return Center(child: Text('Something went wrong: $error'));
          },
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _currentPage,
        builder: (context, pageIndex, child) {
          return BottomNavigationBar(
            currentIndex: pageIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: 'My News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Trending',
              ),
            ],
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
          );
        },
      ),
    );
  }
}


