
import 'package:app_jury/models/Critere.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CritereCard extends StatelessWidget {
  CritereCard({
    this.critere,
    this.tap,
  });

  final Critere critere;
  final Function tap;

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
                    Text(
                      "${critere.libelle} ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Bareme: ${critere.bareme} ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FlatButton(
                        height: 30,
                        color: Colors.black,
                        child: Text(
                          "Modifier",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        textColor: Colors.white,
                        highlightColor: Colors.black,
                        onPressed: () {
                          Navigator.pushNamed(context, '/connexion',
                              arguments: {
                                'critereid': critere.id,
                              });
                        },
                      ),
                    )),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: FlatButton(
                        height: 30,
                        color: Colors.red[900],
                        child: Text(
                          "Supprimer",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        textColor: Colors.white,
                        highlightColor: Colors.black,
                        onPressed: () {
                          Navigator.pushNamed(context, '/connexion',
                              arguments: {
                                'critereid': critere.id,
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
