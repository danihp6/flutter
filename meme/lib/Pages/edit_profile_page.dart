import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

import '../Controller/gallery.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _userName;
  String _description;
  String _avatar;
  ImageMedia _media;
  TextEditingController _nameController, _descriptionController;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    editUser() {
      db.editUser(
          db.userId, _userName, _description, _avatar, _media);
      navigator.pop(context);
    }

    editAvatar(MyMedia media) async {
      _media = media;
      setState(() {});
      navigator.pop(context);
    }

    Widget _buildImage() {
      print(_avatar);
      if (_media != null) return Image.memory(_media.image);
      if (_avatar != '')
        CachedNetworkImage(
          imageUrl: _avatar,
          placeholder: (context, url) => Loading(),
        );
      return Image.asset('assets/images/user.png');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edita tu perfil'),
      ),
      body: StreamBuilder(
          stream: db.getUser(db.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            User user = snapshot.data;
            _userName = user.userName;
            _nameController = new TextEditingController(text: _userName);
            _description = user.description;
            _descriptionController =
                new TextEditingController(text: _description);
            _avatar = user.avatar;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScrollColumnExpandable(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: _buildImage(),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Cambiar foto del perfil',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 15)),
                      ],
                    ),
                    onTap: () async =>
                        await Permission.storage.request().isGranted
                            ? navigator.goGallery(context, editAvatar)
                            : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: TextField(
                      maxLength: 15,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre',
                      ),
                      controller: _nameController,
                      onChanged: (name) => _userName = name,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20,right:20),
                    child: TextFormField(
                      maxLines: 3,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripción',
                      ),
                      controller: _descriptionController,
                      onChanged: (description) => _description = description,
                    ),
                  ),
                  RaisedButton(
                    color: Colors.deepOrange,
                    textColor: Colors.white,
                    child: Text('Confirmar'),
                    onPressed: editUser,
                  )
                ],
              ),
            );
          }),
    );
  }
}
