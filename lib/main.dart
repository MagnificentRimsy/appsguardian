import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/news/data/models/news_model.dart';
import 'features/news/data/models/news_model.g.dart';
import 'features/news/presentation/pages/main_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import the package

void main() async {
  // Ensure the Flutter widgets binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open your box.
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(NewsModelAdapter());
  await Hive.openBox<NewsModel>('news');

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: FutureBuilder<void>(
        future: _initializeApp(),  // Call the initialization function
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
            return MainScreen();  // App ready, show MainScreen
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  // Function to initialize the app
  Future<void> _initializeApp() async {
    try {
      // Initialize Hive and register the adapter
      await Hive.initFlutter();
      Hive.registerAdapter(NewsModelAdapter());
      await Hive.openBox<NewsModel>('news');
    } catch (e) {
      print('Error during Hive initialization: $e');
    }
  }

}
