import 'dart:io';
import 'dart:convert';
import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/models/Groupe.dart';
import 'package:app_jury/models/evenement.dart';

import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddGroupe extends StatefulWidget {
  final int id;
  final String code;
  final String nom;
  final String prenom;
  final String photo;
  final String email;
  final String telephone;
  final Evenement evenement;

  const AddGroupe(
      {Key key,
      this.id,
      this.code,
      this.nom,
      this.prenom,
      this.photo,
      this.email,
      this.telephone,
      this.evenement})
      : super(key: key);

  @override
  _AddGroupeState createState() => _AddGroupeState(
      id, code, nom, prenom, photo, email, telephone, evenement);
}

class _AddGroupeState extends State<AddGroupe> {
  _AddGroupeState(int id, String code, String nom, String prenom, String photo,
      String email, String telephone, Evenement evenement) {
    id = id == null ? null : id;
    nom = nom == null ? null : nom;
    prenom = prenom == null ? null : prenom;
    photo = photo == null ? null : photo;
    telephone = telephone == null ? null : telephone;
    evenement = evenement == null ? null : evenement;
  }

  int id;
  String code;
  String nom;
  String prenom;
  String photo;
  String email;
  String telephone;
  Evenement evenement;

  Future<Groupe> _readGroupe;

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  TextEditingController _codeController;
  TextEditingController _nomController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: body(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/left-arrow.svg"),
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/loupe.svg",
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add.svg",
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Container body(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    //print(arguments['evenement']);
    if (arguments != null) {
      id = arguments['id'];
      code = arguments['code'];
      nom = arguments['nom'];
      photo = arguments['photo'];
      evenement = arguments['evenement'];
      _reset();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Ajouter un groupe",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Container(
              height: 175,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[200], width: 1)),
              child: showImage(),
            ),
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            TextField(
              controller: this._codeController,
              decoration: const InputDecoration(
                labelText: "Code:",
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(),
            TextField(
              controller: this._nomController,
              decoration: const InputDecoration(
                labelText: "Nom:",
                border: OutlineInputBorder(),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _readGroupe = Request.createOrUpdateGroup(
                      id,
                      _codeController.text,
                      _nomController.text,
                      base64Image,
                      evenement.id,
                    );
                    _readGroupe.then((value) => {
                          Navigator.pushNamed(context, '/groupes/id',
                              arguments: {
                                'groupe': value,
                                'evenement': evenement
                              })
                        });
                  },
                  color: Colors.orange,
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ));
  }

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  @override
  void initState() {
    super.initState();
    this._codeController = TextEditingController();
    this._nomController = TextEditingController();
    _reset();
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  void _reset({bool resetControllers = true}) {
    setState(() {
      if (resetControllers) {
        this._codeController.text = code == null ? "" : '$code';
        this._nomController.text = nom == null ? "" : '$nom';
      }
      evenement = evenement;
      base64Image = '$photo';
    });
  }
}
