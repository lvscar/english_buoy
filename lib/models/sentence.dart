// 文章中的每个文字的结构体
import './word.dart';
import 'package:flutter/material.dart';

class Sentence {
  final String starTime;
  final List<Word> words;
  BuildContext c;

  Sentence(this.starTime, this.words);

  Sentence.fromJson(Map json)
      : starTime = json['StarTime'],
        words = (json['Words'] as List).map((d) {
          Word w = Word.fromJson(d);
          return w;
        }).toList();
}
