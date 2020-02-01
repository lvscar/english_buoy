// 文章详情内容
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebuoy/functions/article.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './sentence.dart';
import './word.dart';
import '../store/store.dart';
import '../youtube_player_flutter/lib/youtube_player_flutter.dart';

class Article with ChangeNotifier {
  YoutubePlayerController youtubeController;
  String findWord = ""; //在文章中查找的单词
  int unlearnedCount;
  int articleID;
  Sentence notMasteredWord; // 尚未掌握的table中的单词, 用来滚回去

  // 文章中的文字内容
  // List words = [];
  List<Sentence> sentences;

  // 标题
  String title;
  String youtube;
  String avatar;
  int wordCount;

  setNotMasteredWord(Sentence v) {
    notMasteredWord = v;
    notifyListeners();
  }

  setYouTube(YoutubePlayerController v) {
    youtubeController = v;
  }

  setFindWord(String findWord) {
    this.findWord = findWord;
    notifyListeners();
    // just show 1 seconds
    Future.delayed(Duration(seconds: 1), () {
      this.findWord = "";
      notifyListeners();
    });
  }

  // 从 json 中设置
  setFromJSON(Map json) {
    this.articleID = json['id'];
    this.title = json['title'];
    this.youtube = json['Youtube'];
    this.sentences = (json['Sentences'] as List).map((d) {
      if (d['Words'] != null) {
        return Sentence.fromJson(d);
      }
      return Sentence("", []);
    }).toList();
    this.unlearnedCount = json['UnlearnedCount'];
    this.avatar = json['Avatar'];
    this.wordCount = json['WordCount'];
    notMasteredWord = null;
    notifyListeners();
  }

  /*
  clear() {
    this.youtube = '';
    this.title = '';
    this.sentences.clear();
    // notifyListeners();
  }
   */

  setToLocal(String data) async {
    // 登录后存储到临时缓存中
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('article_' + this.articleID.toString(), data);
  }

  Future getFromLocal(int articleID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('article_' + articleID.toString());
    if (data != null) {
      this.setFromJSON(json.decode(data));
      return true;
    }
    return false;
  }

  // 从服务器获取
  // justUpdateLocal 仅更新本地缓存, 避免延迟导致页面内容错乱
  Future getArticleByID({int articleID, bool justUpdateLocal = false}) async {
    this.articleID = articleID;
    Dio dio = getDio();
    var response =
        await dio.get(Store.baseURL + "article/" + this.articleID.toString());

    if (!justUpdateLocal) this.setFromJSON(response.data);
    this.setToLocal(json.encode(response.data));
    return response;
  }

  //计算已经学会百分比
  computeLearnedPercent() {}

  // 计算未掌握单词数并提交
  Future _putUnlearnedCount() async {
    if (articleID == null) {
      return null;
    }
    // 重新计算未掌握单词数
    List<String> allWords = [];
    for (int i = 0; i < this.sentences.length; i++) {
      List<String> l = this.sentences[i].words.map((d) {
        if (!d.learned && isNeedLearn(d)) {
          return d.text.toLowerCase();
        }
        return "";
      }).toList();
      allWords = List.from(allWords)..addAll(l);
    }
    debugPrint("unleard words=" + allWords.toSet().toString());
    unlearnedCount = allWords.toSet().length;
    unlearnedCount--;
    // 设置本地的列表
    Dio dio = getDio();
    var response = await dio.put(Store.baseURL + "article/unlearned_count",
        data: {"article_id": articleID, "unlearned_count": unlearnedCount});
    return response;
  }

// 设置当前文章这个单词的学习状态
  _setWordIsLearned(String word, bool isLearned) {
    for (int i = 0; i < this.sentences.length; i++) {
      this.sentences[i].words.forEach((d) {
        if (d.text.toLowerCase() == word.toLowerCase()) {
          d.learned = isLearned;
        }
      });
    }
    // notifyListeners();
  }

// 增加学习次数
  increaseLearnCount(String word) {
    for (int i = 0; i < this.sentences.length; i++) {
      this.sentences[i].words.forEach((d) {
        if (d.text.toLowerCase() == word.toLowerCase()) {
          d.count++;
        }
      });
    }
  }

  // 记录学习状态
  Future putLearned(Word word) async {
    // 标记所有单词为对应状态, 并通知
    this._setWordIsLearned(word.text, word.learned);
    return word.putLearned().then((d) => _putUnlearnedCount());
  }
}
