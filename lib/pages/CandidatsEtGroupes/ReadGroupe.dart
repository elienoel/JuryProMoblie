import 'package:app_jury/components/CandidateEtGroupCard/candidatByGroupCard.dart';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Groupe.dart';
import 'package:app_jury/models/evenement.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// ignore: must_be_immutable

class ReadGroupe extends StatefulWidget {
  const ReadGroupe({Key key, this.groupe, this.evenement}) : super(key: key);

  final Groupe groupe;
  final Evenement evenement;

  @override
  _ReadGroupeState createState() => _ReadGroupeState(groupe, evenement);
}

class _ReadGroupeState extends State<ReadGroupe> {
  _ReadGroupeState(Groupe groupe, Evenement evenement) {
    groupe = groupe == null ? null : groupe;
    evenement = evenement == null ? null : evenement;
  }

  Groupe groupe;
  Evenement evenement;

  Future<String> _deleteGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: body(context),
    );
  }

  AppBar buildAppBar() {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    //print(arguments['evenement']);
    if (arguments != null) if (arguments != null) {
      groupe = arguments['groupe'];
      evenement = arguments['evenement'];
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "JURY PRO",
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add-group.svg",
            color: Colors.black,
          ),
          onPressed: () {
            print(groupe);
            print(evenement);
            Navigator.pushNamed(context, '/candidats/add', arguments: {
              'evenement': evenement,
              'groupe': groupe,
            });
          },
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Container body(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) if (arguments != null) {
      groupe = arguments['groupe'];
      evenement = arguments['evenement'];
    }

    Future<Groupe> fetchGroupe() async {
      final response =
          await http.get('${Constant.addressIp}/groupes/${groupe.id}');

      if (response.statusCode == 200) {
        return Groupe.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load Groupe');
      }
    }

    Future<String> deleteGroupe() async {
      final response =
          await http.delete('${Constant.addressIp}/groupes/${groupe.id}');

      if (response.statusCode == 200) {
        return "evenement supprimé";
      } else {
        throw Exception('Failed to load Groupe');
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(1),
      child: (_deleteGroup == null)
          ? FutureBuilder<Groupe>(
              future: fetchGroupe(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: <Widget>[
                        RaisedButton(
                            onPressed: () {
                              setState(() {
                                _deleteGroup = deleteGroupe();
                              });
                            },
                            color: Colors.orange,
                            child: const Text('Supprimer')),
                        RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/groupes/add',
                                  arguments: {
                                    'id': snapshot.data.id,
                                    'code': snapshot.data.code,
                                    'nom': snapshot.data.nom,
                                    'photo': snapshot.data.photo,
                                    'evenementid': snapshot.data.evenementid,
                                  });
                            },
                            color: Colors.orange,
                            child: const Text('Modifier')),
                        Image.memory(
                          Base64Codec().decode(snapshot.data.photo),
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            snapshot.data.nom,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            height: 500,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CandidateByGroupCard(
                              idGroup: snapshot.data.id,
                              nomGroup: snapshot.data.nom,
                            ))
                      ]);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : FutureBuilder<String>(
              future: _deleteGroup,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                        child: Text(snapshot.data),
                      ),
                      RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/groupes');
                          },
                          color: Colors.orange,
                          child:
                              const Text("Retourner a la liste d'evenement")),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
