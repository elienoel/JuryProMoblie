
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Candidat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CandidateCard.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class CandidateByEventCard extends StatefulWidget {
  const CandidateByEventCard({Key key, this.idEvent = 1, this.nomEvent = "",this.tap = defaultFunc,})
      : super(key: key);

  final int idEvent;
  final String nomEvent;
  final Function tap;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _CandidateByEventCardState createState() =>
      _CandidateByEventCardState(idEvent, nomEvent,tap);
}

class _CandidateByEventCardState extends State<CandidateByEventCard> {
  _CandidateByEventCardState(int idEvent, String nomEvent, Function tap) {
    idEvent = idEvent == null ? null : idEvent;
    nomEvent = nomEvent == null ? null : nomEvent;
    tap = tap == null ? null : tap;
  }

  int idEvent = 2;
  String nomEvent = "";
  Function tap;

  Future<List<Candidat>> _fetchCandidat() async {
    final response = await http
        .get('${Constant.addressIp}/candidats/evenement/${widget.idEvent}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsontolist = jsonDecode(response.body) as List;
      
      return jsontolist.map((tagJson) => Candidat.fromJson(tagJson)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Failed to load Evenement');
      throw Exception('Failed to load Evenement');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: EdgeInsets.all(1),
            height: 400,
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
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text("Liste des participant",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                  height: 348,
                  child: FutureBuilder<List>(
                    future: _fetchCandidat(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) =>
                                CandidateCard(candidat: snapshot.data[index]));
                      } else {
                        return Center(
                          child: Text("loading..."),
                        );
                      }
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
