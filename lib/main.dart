
import 'package:app_jury/pages/CandidatsEtGroupes/AddCandidat.dart';
import 'package:app_jury/pages/CandidatsEtGroupes/AddGroupe.dart';
import 'package:app_jury/pages/CandidatsEtGroupes/Candidat.dart';
import 'package:app_jury/pages/CandidatsEtGroupes/ReadGroupe.dart';
import 'package:app_jury/pages/Critere/AddCritere.dart';
import 'package:app_jury/pages/Critere/Critere.dart';
import 'package:app_jury/pages/Evenement/AddEvent.dart';
import 'package:app_jury/pages/Evenement/Event.dart';
import 'package:app_jury/pages/Evenement/ReadEvent.dart';
import 'package:app_jury/pages/Jury/AddJury.dart';
import 'package:app_jury/pages/Jury/Jury.dart';
import 'package:app_jury/pages/Votes/VoteEvent.dart';
import 'package:app_jury/pages/connexion.dart';
import 'package:app_jury/pages/home.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Jury Pro',
        theme: ThemeData(fontFamily: 'OpenSans'),
        initialRoute: "/evenements",
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          // "/onboarding": (BuildContext context) => new Onboarding(),
          "/": (BuildContext context) => new Home(),

          "/evenements": (BuildContext context) => new Event(),
          "/evenements/id": (BuildContext context) => new ReadEvent(),
          "/evenements/add": (BuildContext context) => new AddEvent(),

          "/connexion": (BuildContext context) => new Connexion(),
          "/jury": (BuildContext context) => new Jury(),
          "/jury/add": (BuildContext context) => new AddJury(),

          "/criteres": (BuildContext context) => new Critere(),
          "/criteres/add": (BuildContext context) => new AddCritere(),

           "/candidats": (BuildContext context) => new Candidat(),
          "/candidats/add": (BuildContext context) => new AddCandidat(),


          "/groupes": (BuildContext context) => new Candidat(),
          "/groupes/id": (BuildContext context) => new ReadGroupe(),
          "/groupes/add": (BuildContext context) => new AddGroupe(),

          // "/votes": (BuildContext context) => new Voter(),
          "/votes": (BuildContext context) => new Connexion(),
          "/votes/evenement/id": (BuildContext context) => new VoteEvent(),


          "/resultats/id": (BuildContext context) => new VoteEvent(),
          "/resultats/": (BuildContext context) => new VoteEvent(),
        });
  }
}
