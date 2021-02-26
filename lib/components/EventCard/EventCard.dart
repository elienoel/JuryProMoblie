import 'dart:convert';

import 'package:app_jury/models/evenement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard({this.evenement});
  final Evenement evenement;

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
                    Base64Codec().decode(evenement.image),
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    evenement.nom,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Du ${evenement.dateDebut} au ${evenement.dateFin}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "${evenement.participant} participant",
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
                          arguments: {'evenement': evenement});
                    },
                  ),
                )),
              ],
            )),
      ],
    );
  }
}
