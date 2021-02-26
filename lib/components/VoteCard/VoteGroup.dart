import 'dart:convert';
import 'dart:ffi';

import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/models/Groupe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VoteGroup extends StatefulWidget {
  final int juryid;
  final Groupe groupe;

  const VoteGroup({Key key, this.juryid, this.groupe}) : super(key: key);

  @override
  _VoteGroupState createState() => _VoteGroupState(juryid, groupe);
}

class _VoteGroupState extends State<VoteGroup> {
  _VoteGroupState(int juryid, Groupe groupe) {
    juryid = juryid == null ? null : juryid;
    groupe = groupe == null ? null : groupe;
  }

  int juryid;
  Groupe groupe;
  String commentaire;
  TextEditingController _commentaireController;
  Map _note = {};

  bool _noteSend = false;

  @override
  Widget build(BuildContext context) {
    return (_noteSend)
        ? Container(
            padding: EdgeInsets.all(1),
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.grey,
                width: 0.2,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.audiotrack,
                    color: Colors.green,
                    size: 30.0,
                  ),
                  Text("Note enregistrée")
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Container(
                padding: EdgeInsets.all(1),
                height: 340,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          width: double.infinity,
                          child: Image.memory(
                            Base64Codec().decode(widget.groupe.photo),
                            fit: BoxFit.fill,
                          ),
                        )),
                    Container(
                        padding: const EdgeInsets.all(5),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text("${widget.groupe.nom}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Container(
                      height: 120,
                      child: FutureBuilder<List>(
                        future: Request.getCritereByEvent(
                            widget.groupe.evenementid),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) => Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${snapshot.data[index].libelle} :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                          Container(
                                            child: RatingBar.builder(
                                              itemSize: 22,
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                int idm =
                                                    snapshot.data[index].id;

                                                _note[idm] = ((snapshot
                                                                .data[index]
                                                                .bareme *
                                                            rating) /
                                                        5)
                                                    .toInt();
                                                print(_note);
                                                // note[idm] =
                                                //     (snapshot.data[index].bareme * rating) /
                                                //         5;
                                                // print(note);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                          } else {
                            return Center(
                              child: Text("loading..."),
                            );
                          }
                        },
                      ),
                    ),
                    RaisedButton(
                        onPressed: () {
                          _note.forEach((key, value) {
                            int critere = key;
                            int valeur = value;
                            Request.saveNote(
                                widget.groupe.evenementid,
                                widget.juryid,
                                widget.groupe.id,
                                critere,
                                valeur,
                                commentaire,false);
                          });
                          setState(() {
                            _noteSend = true;
                          });
                        },
                        color: Colors.orange,
                        child: const Text('VALIDER'))
                  ],
                )),
          );
  }
}
