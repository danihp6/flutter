import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import '../Controller/db.dart';

class FavouriteButton extends StatefulWidget {
  Post post;
  String userId;
  FavouriteButton({@required this.post, @required this.userId});

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    List<String> favourites = widget.post.favourites;
    if (favourites.contains(db.userId))
      return IconButton(
          icon: Icon(Icons.star),
          iconSize: 30,
          padding: EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              db.deletePostPathInFavourites(
                  db.userId, 'users/${widget.userId}/posts/${widget.post.id}');
            });
          });

    return IconButton(
        icon: Icon(Icons.star_border),
        iconSize: 30,
        padding: EdgeInsets.all(0),
        onPressed: () {
          setState(() {
            db.addPostPathInFavourites(
                db.userId, 'users/${widget.userId}/posts/${widget.post.id}');
          });
        });
  }
}
