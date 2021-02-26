import 'package:app_jury/components/CandidateEtGroupCard/GroupeByEventCard.dart';
import 'package:app_jury/components/CandidateEtGroupCard/candidatByEventCard.dart';
import 'package:app_jury/components/CritereCard/CritereByEventCard.dart';
import 'package:app_jury/components/JuryCard/JuryByEventCard.dart';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/evenement.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// ignore: must_be_immutable

class ReadEvent extends StatefulWidget {
  const ReadEvent({Key key, this.evenement}) : super(key: key);

  final Evenement evenement;

  @override
  _ReadEventState createState() => _ReadEventState(evenement);
}

class _ReadEventState extends State<ReadEvent> {
  _ReadEventState(Evenement evenement) {
    evenement = evenement == null ? null : evenement;
  }

  Evenement evenement;

  Future<String> _deleteEvent;

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
            "assets/icons/add.svg",
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/criteres/add',
                arguments: {'evenementid': evenement.id});
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add-user.svg",
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/jury/add',
                arguments: {'evenementid': evenement.id});
          },
        ),
        (evenement.type == "INDIVIDUEL")
            ? IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/add-group.svg",
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/candidats/add',
                      arguments: {'evenement': evenement});
                },
              )
            : IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/add-group.svg",
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/groupes/add',
                      arguments: {'evenement': evenement});
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
    //print(arguments['evenement']);
    if (arguments != null) if (arguments != null) {
      evenement = arguments['evenement'];
    }

    Future<String> deleteEvenement() async {
      final response =
          await http.delete('${Constant.addressIp}/evenements/$evenement');

      if (response.statusCode == 200) {
        return "evenement supprimé";
      } else {
        throw Exception('Failed to load Evenement');
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(1),
      child: (_deleteEvent == null)
          ? ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      _deleteEvent = deleteEvenement();
                    });
                  },
                  color: Colors.orange,
                  child: const Text('Supprimer')),
              RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/evenements/add', arguments: {
                      'evenement': evenement.id,
                      'dateDebut': evenement.dateDebut,
                      'dateFin': evenement.dateFin,
                      'nom': evenement.nom,
                      'type': evenement.type,
                      'image': evenement.image,
                    });
                  },
                  color: Colors.orange,
                  child: const Text('Modifier')),
              Image.memory(
                Base64Codec().decode(evenement.image),
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  evenement.nom,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  "Du ${evenement.dateDebut} au ${evenement.dateFin})",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                  height: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CritereByEventCard(
                    idEvent: evenement.id,
                    nomEvent: evenement.nom,
                  )),
              Container(
                  height: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: JuryByEventCard(
                    idEvent: evenement.id,
                  )),
              Container(
                  height: 500,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: (evenement.type == "INDIVIDUEL")
                      ? CandidateByEventCard(
                          idEvent: evenement.id,
                          nomEvent: evenement.nom,
                        )
                      : GroupeByEventCard(
                          evenement: evenement,
                        )),
            ])
          : FutureBuilder<String>(
              future: _deleteEvent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                        child: Text(snapshot.data),
                      ),
                      RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/evenements');
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
