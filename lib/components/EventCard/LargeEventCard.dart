import 'dart:convert';

import 'package:app_jury/models/evenement.dart';
import 'package:app_jury/models/jury.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LargeEventCard extends StatelessWidget {
  LargeEventCard({
    this.evenement,
    this.jury,
  });

  final Evenement evenement;
  final Jury jury;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(padding: EdgeInsets.all(10)),
        Container(
            padding: EdgeInsets.all(5),
            height: 230,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
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
                  "Du ${DateFormat.yMd().format(evenement.dateDebut)} au ${evenement.dateFin}",
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
                      Navigator.pushNamed(context, '/votes/evenement/id',
                          arguments: {'evenement': evenement,'jury':jury});
                    },
                  ),
                )),
              ],
            )),
      ],
    );
  }
}
