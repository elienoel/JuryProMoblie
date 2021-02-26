import 'dart:io';
import 'dart:convert';
import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/models/Candidat.dart';
import 'package:app_jury/models/Groupe.dart';
import 'package:app_jury/models/evenement.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCandidat extends StatefulWidget {
  final int id;
  final String code;
  final String nom;
  final String prenom;
  final String photo;
  final String email;
  final String telephone;
  final Evenement evenement;
  final Groupe groupe;

  const AddCandidat(
      {Key key,
      this.id,
      this.code,
      this.nom,
      this.prenom,
      this.photo,
      this.email,
      this.telephone,
      this.evenement,
      this.groupe})
      : super(key: key);

  @override
  _AddCandidatState createState() => _AddCandidatState(
      id, code, nom, prenom, photo, email, telephone, evenement, groupe);
}

class _AddCandidatState extends State<AddCandidat> {
  _AddCandidatState(
      int id,
      String code,
      String nom,
      String prenom,
      String photo,
      String email,
      String telephone,
      Evenement evenement,
      Groupe groupe) {
    id = id == null ? null : id;
    nom = nom == null ? null : nom;
    prenom = prenom == null ? null : prenom;
    photo = photo == null ? null : photo;
    telephone = telephone == null ? null : telephone;
    evenement = evenement == null ? null : evenement;
    groupe = groupe == null ? null : groupe;
  }

  int id;
  String code;
  String nom;
  String prenom;
  String photo;
  String email;
  String telephone;

  Evenement evenement;
  Groupe groupe;

  Future<Candidat> _readCandidat;

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  TextEditingController _codeController;
  TextEditingController _nomController;
  TextEditingController _prenomController;
  TextEditingController _emailController;
  TextEditingController _telephoneController;

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
    if (arguments != null) if (arguments != null) {
      id = arguments['id'];
      code = arguments['code'];
      nom = arguments['nom'];
      prenom = arguments['prenom'];
      photo = arguments['photo'];
      email = arguments['email'];
      telephone = arguments['telephone'];
      evenement = arguments['evenement'];
      groupe = arguments['groupe'];
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
                      "Ajouter un candidat",
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
                  const Divider(),
                  TextField(
                    controller: this._prenomController,
                    decoration: const InputDecoration(
                      labelText: "Prenom:",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: this._emailController,
                    decoration: const InputDecoration(
                      labelText: "email:",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: this._telephoneController,
                    decoration: const InputDecoration(
                      labelText: "Telephone:",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          _readCandidat = Request.createOrUpdateCandidate(
                              id,
                              _codeController.text,
                              _nomController.text,
                              _prenomController.text,
                              _emailController.text,
                              _telephoneController.text,
                              base64Image,
                              evenement.id,
                              groupe);
                          _readCandidat.then((value) => {
                                (groupe != null)
                                    ? Navigator.pushNamed(
                                        context, '/groupes/id', arguments: {
                                        'groupe': groupe,
                                        'evenement': evenement
                                      })
                                    : Navigator.pushNamed(
                                        context, '/evenements/id',
                                        arguments: {'evenement': evenement})
                              });
                        },
                        color: Colors.orange,
                        child: const Text('Enregistrer'),
                      ),
                    ],
                  ),
                ],
              )
            );
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
    this._prenomController = TextEditingController();
    this._emailController = TextEditingController();
    this._telephoneController = TextEditingController();
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
        this._prenomController.text = prenom == null ? "" : '$prenom';
        this._emailController.text = email == null ? '' : '$email';
        this._telephoneController.text = telephone == null ? '' : '$telephone';
      }
      evenement = evenement;
      groupe = groupe;
      base64Image = '$photo';
    });
  }
}

class AddCandidateToGroup {}
