import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';  // Import the preloader package
import '../../domain/entitites/news.dart';
import '../providers/news_provider.dart';

class AddNewsScreen extends ConsumerStatefulWidget {
  const AddNewsScreen({super.key});

  @override
  ConsumerState<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends ConsumerState<AddNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: "Breaking News");
  final _contentController = TextEditingController(text: "Important news content...");
  final _sourceController = TextEditingController(text: "News Source");
  final _pictureController = TextEditingController(text: 'https://example.com/sample-image.jpg');
  List<String> images = [];

  bool _isLoading = false;  // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add News'),
      ),
      body: _isLoading  // Show preloader when loading
          ? Center(
        child: LoadingAnimationWidget.staggeredDotsWave(  // Preloader widget
          color: Colors.blue,
          size: 50,
        ),
      )
          : Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source'),
            ),
            TextFormField(
              controller: _pictureController,
              decoration: InputDecoration(labelText: 'Photo URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;  // Start loading
                });

                images.add(_pictureController.text);
                if (_formKey.currentState!.validate()) {
                  final newNewsArticle = NewsArticle(
                    title: _titleController.text,
                    images: images,
                    content: _contentController.text,
                    date: DateTime.now(),
                    source: _sourceController.text,
                  );
                  await ref.read(newsListNotifierProvider.notifier).addNewsArticle(newNewsArticle);
                  await ref.read(newsListNotifierProvider.notifier).loadNewsArticles();

                  setState(() {
                    _isLoading = false;  // End loading
                  });
                  // Navigator.pop(context);  // Optional: Close screen after submitting
                }
              },
              child: Text('Add News'),
            ),
          ],
        ),
      ),
    );
  }
}
