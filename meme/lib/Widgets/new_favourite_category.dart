import 'package:flutter/material.dart';
import 'package:meme/Pages/new_favourite_category_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class NewFavouriteCategory extends StatelessWidget {
  String userId;
  NewFavouriteCategory({this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text('Añadir nueva categoria'),
            ],
          ),
        ),
        onTap: ()=>Navigator.push(context, SlideLeftRoute(page:NewFavouriteCategoryPage(userId:userId))),
      );
  }
}