import 'dart:convert';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/jury.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddJury extends StatefulWidget {
  final int id;
  final String code;
  final String nomComplet;
  final String telephone;
  final int evenementid;

  const AddJury(
      {Key key,
      this.id,
      this.code,
      this.nomComplet,
      this.telephone,
      this.evenementid})
      : super(key: key);

  @override
  _AddJuryState createState() =>
      _AddJuryState(id, code, nomComplet, telephone, evenementid);
}

class _AddJuryState extends State<AddJury> {
  _AddJuryState(int id, String code, String nomComplet, String telephone,
      int evenementid) {
    id = id == null ? null : id;
    code = code == null ? null : code;
    nomComplet = nomComplet == null ? null : nomComplet;
    telephone = telephone == null ? null : telephone;
    evenementid = evenementid == null ? null : evenementid;
  }

  int id;
  String code;
  String nomComplet;
  String telephone;
  int evenementid;

  Future<Jury> _readJury;

  TextEditingController _codeController;
  TextEditingController _nomCompletController;
  TextEditingController _telephoneController;

  Future<Jury> _httpPost(
      String code, String nomComplet, String telephone) async {
    if (id == null) {
      final response = await http.post(
        '${Constant.addressIp}/jurys/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'code': code,
          'nom_complet': nomComplet,
          'telephone': telephone,
          'evenementid': evenementid,
        }),
      );
      // If the server did return a 201 CREATED response.
      if (response.statusCode == 200) {
        return Jury.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('la creation de evenement a echoué.');
      }
    } else {
      final response = await http.post(
        '${Constant.addressIp}/jurys/$id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'code': code,
          'nom_complet': nomComplet,
          'telephone': telephone,
          'evenementid': evenementid,
        }),
      );

      if (response.statusCode == 200) {
        return Jury.fromJson(jsonDecode(response.body));
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
      code = arguments['code'];
      nomComplet = arguments['nomComplet'];
      telephone = arguments['telephone'];
      evenementid = arguments['evenementid'];
      _reset();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: (_readJury == null)
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Ajouter un jury",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
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
                    controller: this._nomCompletController,
                    decoration: const InputDecoration(
                      labelText: "Nom Complet du Jury:",
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
                          setState(() {
                            _readJury = this._httpPost(
                              _codeController.text,
                              _nomCompletController.text,
                              _telephoneController.text,
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
            : FutureBuilder<Jury>(
                future: _readJury,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              snapshot.data.code,
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
                              snapshot.data.nomComplet,
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
    this._codeController = TextEditingController();
    this._nomCompletController = TextEditingController();
    this._telephoneController = TextEditingController();
    _reset();
  }

  void _reset({bool resetControllers = true}) {
    setState(() {
      if (resetControllers) {
        this._codeController.text = code == null ? "" : '$code';
        this._nomCompletController.text =
            nomComplet == null ? "" : '$nomComplet';
        this._telephoneController.text = telephone == null ? '' : '$telephone';
      }
       evenementid = evenementid;
    });
  }
}
