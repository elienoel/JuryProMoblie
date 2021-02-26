import 'dart:io';
import 'dart:convert';
import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/models/evenement.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddEvent extends StatefulWidget {
  final int id;
  final String nom;
  final String type;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String image;

  const AddEvent(
      {Key key,
      this.id,
      this.nom,
      this.type,
      this.dateDebut,
      this.dateFin,
      this.image})
      : super(key: key);

  @override
  _AddEventState createState() =>
      _AddEventState(id, nom, type, dateDebut, dateFin, image);
}

class _AddEventState extends State<AddEvent> {
  _AddEventState(int id, String nom, String type, DateTime dateDebut,
      DateTime dateFin, String image) {
    id = id == null ? null : id;
    nom = nom == null ? null : nom;
    type = type == null ? null : type;
    dateDebut = dateDebut == null ? null : dateDebut;
    dateFin = dateFin == null ? null : dateFin;
    image = image == null ? null : image;
  }

  int id;
  String nom;
  String type;
  String image;
  DateTime dateDebut;
  DateTime dateFin;

  Future<Evenement> _readEvent;

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  TextEditingController _typeController;
  TextEditingController _nomController;
  TextEditingController _dateDebutController;
  TextEditingController _dateFinController;


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
      type = arguments['type'];
      nom = arguments['nom'];
      dateDebut = arguments['dateDebut'];
      dateFin = arguments['dateFin'];
      image = arguments['image'];
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
                "Ajouter un evenement",
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
              controller: this._nomController,
              decoration: const InputDecoration(
                labelText: "Nom de l'evenement:",
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(),
            TextField(
              controller: this._typeController,
              decoration: const InputDecoration(
                labelText: "Type d'evenement:",
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(),
            TextField(
              controller: this._dateDebutController,
              decoration: const InputDecoration(
                labelText: "Date de debut:",
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(),
            TextField(
              controller: this._dateFinController,
              decoration: const InputDecoration(
                labelText: "Date de fin:",
                border: OutlineInputBorder(),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _readEvent = Request.createOrUpdateEvent(
                        id,
                        _typeController.text,
                        _nomController.text,
                        _dateDebutController.text,
                        _dateFinController.text,
                        base64Image);

                    _readEvent.then((value) {
                      print(value.id);
                      Navigator.pushNamed(context, '/evenements/id',
                          arguments: {'evenement': value});
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
    this._typeController = TextEditingController();
    this._nomController = TextEditingController();
    this._dateDebutController = TextEditingController();
    this._dateFinController = TextEditingController();
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
        this._typeController.text = type == null ? "" : '$type';
        this._nomController.text = nom == null ? "" : '$nom';
        this._dateDebutController.text =
            dateDebut == null ? '2021-01-01' : '$dateDebut';
        this._dateFinController.text =
            dateFin == null ? '2021-12-01' : '$dateFin';
      }
      base64Image = '$image';
    });
  }
}
