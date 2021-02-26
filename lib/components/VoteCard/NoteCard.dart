import 'package:app_jury/models/Critere.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  NoteCard({
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
                      "${critere.libelle}:",
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
                          "Noter",
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
