import 'dart:convert';

import 'package:app_jury/models/Groupe.dart';
import 'package:app_jury/models/evenement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupeCard extends StatelessWidget {
  GroupeCard({
    this.groupe,
    this.evenement,
  });

  final Groupe groupe;
  final Evenement evenement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(5)),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.memory(
                        Base64Codec().decode(groupe.photo),
                        fit: BoxFit.fill,
                      ),
                      height: 60,
                    ),
                    Text(
                      "${groupe.nom}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "NOTES",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FlatButton(
                        height: 30,
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
                          print("Evenement: $evenement");
                          Navigator.pushNamed(context, '/groupes/id',
                              arguments: {
                                'groupe': groupe,
                                'evenement': evenement,
                              });
                        },
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
