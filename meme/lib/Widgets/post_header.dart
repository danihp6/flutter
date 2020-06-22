import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/storage.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/favourite_button.dart';
import 'package:meme/Widgets/post_menu.dart';
import 'package:meme/Widgets/slide_left_route.dart';

import 'loading.dart';

class PostHeader extends StatelessWidget {
  Post post;
  PostList postList;
  PostHeader({@required this.post, this.postList});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getUser(post.getAuthorId()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          User user = snapshot.data;
          return Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.getAvatar()),
              ),
              SizedBox(width: 10),
              Text(
                user.getUserName(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      post.getFavourites().length.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    StreamBuilder(
                        stream: getUser(configuration.getUserId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData)
                            return Loading();
                          User user = snapshot.data;
                          return Row(
                            children: [
                              FavouriteButton(
                                  postId: post.getId(), userId: user.getId()),
                              SizedBox(
                                width: 35,
                                child: PostMenu(
                                  post: post,
                                  userId: user.getId(),
                                  postList: postList,
                                ),
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
