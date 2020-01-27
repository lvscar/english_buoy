// 文章中的每个文字的结构体
import 'dart:async';
import '../store/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import './sentence.dart';

class Word with ChangeNotifier {
  Sentence belongSentence; // 属于哪一个句子
  final String text;
  final int level;
  bool learned;
  int count;

  Word(this.text, [this.level, this.learned = false, this.count = 0]);

  Word.fromJson(Map json)
      : text = json['text'],
        learned = json['learned'],
        level = json['level'],
        count = json['count'];

  Map toJson() => {
        'text': text,
        'learned': learned,
        'count': count,
        'level': level,
      };

// 记录学习状态
  Future putLearned() async {
    // 标记所有单词为对应状态, 并通知
    Dio dio = getDio();
    var response = await dio.put(Store.baseURL + "learned",
        data: {"word": this.text, "learned": this.learned});
    //提交未学会单词数(其实可以放在后台, 或者和上面的提交合并)
    // _putUnlearnedCount();
    return response;
  }

// 记录学习次数
  Future putLearn() async {
    Dio dio = getDio();
    var response =
        await dio.put(Store.baseURL + "learn", data: {"word": this.text});
    return response;
  }
}
