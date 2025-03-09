import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/news/data/models/news_model.dart';
import 'features/news/data/models/news_model.g.dart';
import 'features/news/presentation/pages/main_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  try {
    // Initialize Hive (No need for appDir)
    await Hive.initFlutter();

    // Register Hive Adapter (Make sure it's generated)
    Hive.registerAdapter(NewsModelAdapter());

    // Open Hive Box Safely
    if (!Hive.isBoxOpen('news')) {
      await Hive.openBox<NewsModel>('news');
    }

    // Run the app
    runApp(ProviderScope(child: MyApp()));
  } catch (e, stack) {
    debugPrint('🔥 Error initializing Hive: $e\n$stack'); // Log error for debugging
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: FutureBuilder<void>(
        future: Future.delayed(Duration(seconds: 2)), // Optional delay
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.flickr(
                  size: 50,
                  leftDotColor: Colors.red,
                  rightDotColor: Colors.black87,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            return MainScreen(); // App ready, show MainScreen
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
