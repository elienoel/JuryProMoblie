import 'package:app_jury/components/ResultCard/ResultByJury.dart';
import 'package:app_jury/components/VoteCard/VoteCandidatByEvent.dart';
import 'package:app_jury/components/VoteCard/VoteGroupByEvent.dart';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/evenement.dart';
import 'package:app_jury/models/jury.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// ignore: must_be_immutable

class VoteEvent extends StatefulWidget {
  const VoteEvent({Key key, this.evenement,this.jury}) : super(key: key);

  final Evenement evenement;
  final Jury jury;

  @override
  _VoteEventState createState() => _VoteEventState(evenement,jury);
}

class _VoteEventState extends State<VoteEvent> {
  _VoteEventState(Evenement evenement,Jury jury) {
    evenement = evenement == null ? null : evenement;
    jury = jury == null ? null : jury;
  }

  Evenement evenement;
  Jury jury;


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
     if (arguments != null) {
      evenement = arguments['evenement'];
      jury = arguments['jury'];
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(evenement.nom,style: TextStyle(color: Colors.black),),
    );
  }

  Container body(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      evenement = arguments['evenement'];
      jury = arguments['jury'];
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(1),
      child:ListView(
                      padding: const EdgeInsets.all(5.0),
                      children: <Widget>[
                        Image.memory(
                          Base64Codec().decode(evenement.image),
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            evenement.nom,
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
                            "Du ${evenement.dateDebut} au ${evenement.dateFin})",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                            height: 300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ResultByJury(
                              evenement: evenement,
                              juryid: jury.id,
                            )),
                        Container(
                            height: 400,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child:(evenement.type=="INDIVIDUEL")
                            ? VoteCandidateByEvent(
                              evenementid: evenement.id,
                              juryid: jury.id,
                            )
                            :VoteGroupByEvent(
                              evenementid: evenement.id,
                              juryid: jury.id,
                            )
                            ),
                      ])
               
    );
  }
}
