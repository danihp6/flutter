import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list.dart';

class SelectPostList extends StatelessWidget {
  String postId;

  SelectPostList({@required this.postId});

  String postListId;

  @override
  Widget build(BuildContext context) {
    addPublicationAndGoBack() {
      addPostPathInPostList(configuration.getUserId(), postId,postListId);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una lista'),
      ),
      body: StreamBuilder(
          stream: getPostLists(configuration.getUserId()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            List<PostList> postLists = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(left:8,right:8),
              child: ListView.builder(
                itemCount: postLists.length,
                itemBuilder: (context, index) {
                  return PostListWidget(
                    postList: postLists[index],
                    activeMoreOptions: false,
                    onTap: () {
                      postListId = postLists[index].getId();
                      addPublicationAndGoBack();
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}