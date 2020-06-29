import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import '../Controller/db.dart';

class LikeCommentButton extends StatefulWidget {
  Comment comment;
  
  LikeCommentButton({@required this.comment});

  @override
  _LikeCommentButtonState createState() => _LikeCommentButtonState();
}

class _LikeCommentButtonState extends State<LikeCommentButton> {
  List<String> _likes;
  Comment _comment;
  @override
  Widget build(BuildContext context) {
    _likes = widget.comment.likes;
    _comment = widget.comment;
    if (_likes.contains(db.userId))
      return IconButton(
          icon: Icon(Icons.favorite),
          iconSize: 30,
          onPressed: () {
            setState(() {
              db.unlikeComment(_comment.userPostId,_comment.postId,_comment.id,db.userId);
            });
          });

    return IconButton(
        icon: Icon(Icons.favorite_border),
        iconSize: 30,
        onPressed: () {
          setState(() {
            db.likeComment(_comment.userPostId,_comment.postId,_comment.id,db.userId);
          });
        });
  }
}
