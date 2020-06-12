import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'slide_left_route.dart';
import '../Pages/favourite_category_page.dart';

class FavouriteCategoryWidget extends StatefulWidget {
  FavouriteCategory favouriteCategory;

  FavouriteCategoryWidget(
      {this.favouriteCategory});

  @override
  _FavouriteCategoryWidgetState createState() =>
      _FavouriteCategoryWidgetState();
}

class _FavouriteCategoryWidgetState extends State<FavouriteCategoryWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    FavouriteCategory _favouriteCategory = widget.favouriteCategory;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 70,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              color: Colors.grey[300],
              child: Image.network(_favouriteCategory.getImage()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              _favouriteCategory.getName(),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Icon(Icons.more_vert)]),
            )
          ],
        ),
      ),
      onTap: ()=>Navigator.of(context).push(SlideLeftRoute(page:FavouriteCategoryPage(favouriteCategory:_favouriteCategory))),
    );
  }
}