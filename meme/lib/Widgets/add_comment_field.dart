import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class AddCommentField extends StatefulWidget {
  User user;
  String postId;
  AddCommentField({@required this.user, @required this.postId});

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  String text = '';
  TextEditingController controller = new TextEditingController();
  FocusNode focus = new FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void sendComment() {
      newComment(
          configuration.getUserId(),
          widget.postId,
          new Comment(text, <String>[], configuration.getUserId(),
              DateTime.now(), <String>[], 0));
      controller.clear();
      text = '';
      focus.unfocus();
    }

    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(widget.user.getAvatar()),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                hintText: 'Escribe un comentario',
                border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                text = value;
              });
            },
            controller: controller,
            focusNode: focus,
          ),
        ),
        if (text.length > 0)
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendComment,
          )
      ],
    );
  }
}
