import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/string_functions.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/user_avatar.dart';

class AddCommentField extends StatefulWidget {
  User user;
  String postId;
  AddCommentField({@required this.user, @required this.postId});

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  String text;
  TextEditingController controller;
  FocusNode focus;
  bool isMentionsShowed;

@override
  void initState() {
    text = '';
    isMentionsShowed = false;
    controller = new TextEditingController();
    controller.addListener(() {
      if(controller.selection.baseOffset>0){
      int startWordIndex = startIndexWordAtPosition(controller.value.text, controller.selection.baseOffset-1);
      print(startWordIndex);
       if (controller.value.text[startWordIndex] == '@' && (startWordIndex-1 == 0 || controller.value.text[startWordIndex-2] == ' '))print('@');
      }
     });
    focus = new FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

      

  @override
  Widget build(BuildContext context) {
    void sendComment() {
      db.newComment(
          db.userId,
          widget.postId,
          new Comment(text, <String>[], db.userId,
              DateTime.now(), <String>[], 0));
      controller.clear();
      text = '';
      focus.unfocus();
    }

bool possibleMention(){
        if(text[controller.selection.baseOffset] == '@') return true;
        return false;
    }

    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        SizedBox(height:30,width:30,child: UserAvatar(user: widget.user)),
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
