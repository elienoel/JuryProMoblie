import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard(
      {this.id = 1,
      this.image = "",
      this.nom = "",
      this.dateDebut = "",
      this.dateFin = "",
      this.participant = 0,
      this.tap = defaultFunc});

  final int id;
  final String image;
  final Function tap;
  final String nom;
  final String dateDebut;
  final String dateFin;
  final int participant;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(padding: EdgeInsets.all(10)),
        Container(
            padding: EdgeInsets.all(5),
            height: 205,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  child: Image.memory(
                    Base64Codec().decode(image),
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    nom,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Du $dateDebut au $dateFin",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "$participant participant",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FlatButton(
                    height: 20,
                    color: Colors.orangeAccent,
                    child: Text(
                      "Voir",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    textColor: Colors.white,
                    highlightColor: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, '/evenements/id',
                          arguments: {'id': id});
                    },
                  ),
                )),
              ],
            )),
      ],
    );
  }
}
