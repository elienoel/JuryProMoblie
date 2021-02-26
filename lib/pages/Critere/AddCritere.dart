import 'dart:convert';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Critere.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCritere extends StatefulWidget {
  final int id;
  final String libelle;
  final int bareme;
  final int evenementid;

  const AddCritere(
      {Key key,
      this.id,
      this.libelle,
      this.bareme,
      this.evenementid,})
      : super(key: key);

  @override
  _AddCritereState createState() =>
      _AddCritereState(id,libelle,bareme,evenementid);
}

class _AddCritereState extends State<AddCritere> {
  _AddCritereState(int id, String libelle, int bareme, int evenementid) {
    id = id == null ? null : id;
    libelle = libelle == null ? null : libelle;
    bareme = bareme == null ? null : bareme;
    evenementid = evenementid == null ? null : evenementid;
  }

  int id;
  String libelle;
  int bareme;
  int evenementid;

  Future<Critere> _readCritere;

  TextEditingController _libelleController;
  TextEditingController _baremeController;

  Future<Critere> _httpPost(
      String libelle, String bareme,) async {
    if (id == null) {
      final response = await http.post(
        '${Constant.addressIp}/criteres/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'libelle': libelle,
          'bareme': int.parse(bareme),
          'evenementid': evenementid,
        }),
      );
      // If the server did return a 201 CREATED response.
      if (response.statusCode == 200) {
        return Critere.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('la creation de evenement a echoué.');
      }
    } else {
      final response = await http.post(
        '${Constant.addressIp}/criteres/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'libelle': libelle,
          'bareme': int.parse(bareme),
          'evenementid': evenementid,
        }),
      );

      if (response.statusCode == 200) {
        return Critere.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('la creation de evenement a echoué.');
      }
    }
  }

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
      libelle = arguments['libelle'];
      bareme = arguments['bareme'];
      evenementid = arguments['evenementid'];
      _reset();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: (_readCritere == null)
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Ajouter un Critere",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: this._libelleController,
                    decoration: const InputDecoration(
                      labelText: "Libelle",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: this._baremeController,
                    decoration: const InputDecoration(
                      labelText: "Barreme",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _readCritere = this._httpPost(
                              _libelleController.text,
                              _baremeController.text,
                            );
                          });
                        },
                        color: Colors.orange,
                        child: const Text('Enregistrer'),
                      ),
                    ],
                  ),
                ],
              )
            : FutureBuilder<Critere>(
                future: _readCritere,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              snapshot.data.libelle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              '${snapshot.data.bareme}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ]);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ));
  }

  @override
  void initState() {
    super.initState();
    this._libelleController = TextEditingController();
    this._baremeController = TextEditingController();
    _reset();
  }

  void _reset({bool resetControllers = true}) {
    setState(() {
      if (resetControllers) {
        this._libelleController.text = libelle == null ? "" : '$libelle';
        this._baremeController.text =
            bareme == null ? "" : '$bareme';
      }
      evenementid = evenementid;
    });
  }
}
