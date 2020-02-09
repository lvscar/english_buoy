import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './article_titles.dart';
import 'article_page_view.dart';
import '../models/controller.dart';
import '../models/article_titles.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Controller _controller;
  ArticleTitles _articleTitles;

  static List<BottomNavigationBarItem> bottomNavigationBarItem =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.library_books),
      title: Text('Article'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_library),
      title: Text('Lib'),
    ),
  ];
  @override
  void initState() {
    super.initState();
    _articleTitles = Provider.of<ArticleTitles>(context, listen: false);
    _controller = Provider.of<Controller>(context, listen: false);
  }

  /*
  void _onItemTapped(int index) {
    _controller.setMainSelectedIndex(index);
  }
  */

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, currentController, child) {
        return Scaffold(
          body: PageView(
            children: [
              ArticleTitlesPage(),
              ArticlePageViewPage(),
              Center(child: Text('Developing')),
            ],
            controller: _controller.mainPageController,
            onPageChanged: (index) {
              _articleTitles.pauseYouTube();
            },
          ),
          /*
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavigationBarItem,
            currentIndex: currentController.mainSelectedIndex,
            onTap: _onItemTapped,
          ),
          */
        );
      },
    );
  }
}
