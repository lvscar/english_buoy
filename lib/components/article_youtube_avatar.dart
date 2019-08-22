import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArticleYoutubeAvatar extends StatelessWidget {
  const ArticleYoutubeAvatar({this.youtubeURL, this.avatar, Key key})
      : super(key: key);
  final String youtubeURL;
  final String avatar;
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: youtubeURL == '' ? false : true,
        child: avatar == ''
            ? Icon(
                FontAwesomeIcons.youtube,
                color: Colors.red,
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(avatar),
              ));
  }
}