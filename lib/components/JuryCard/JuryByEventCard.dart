import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/jury.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'JuryCard.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class JuryByEventCard extends StatefulWidget {
  const JuryByEventCard({Key key, this.idEvent = 1, this.nomEvent = ""})
      : super(key: key);

  final int idEvent;
  final String nomEvent;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _JuryByEventCardState createState() =>
      _JuryByEventCardState(idEvent, nomEvent);
}

class _JuryByEventCardState extends State<JuryByEventCard> {
  _JuryByEventCardState(int idEvent, String nomEvent) {
    idEvent = idEvent == null ? null : idEvent;
    nomEvent = nomEvent == null ? null : nomEvent;
  }

  int idEvent = 2;
  String nomEvent = "";

  Future<List<Jury>> _fetchJury() async {
    final response = await http
        .get('${Constant.addressIp}/jurys/evenement/${widget.idEvent}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsontolist = jsonDecode(response.body) as List;
      return jsontolist.map((tagJson) => Jury.fromJson(tagJson)).toList();
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
        Padding(padding: EdgeInsets.all(10)),
        Container(
            padding: EdgeInsets.all(5),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black,
                width: 0.7,
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
                        child: Text(widget.nomEvent,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                  height: 140,
                  child: FutureBuilder<List>(
                    future: _fetchJury(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) =>
                                JuryCard(jury: snapshot.data[index]));
                      } else {
                        return Center(
                          child: Text("loading..."),
                        );
                      }
                    },
                  ),
                ),
                Divider(height: 2),
                Container(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FlatButton(
                    height: 20,
                    color: Colors.orangeAccent,
                    child: Text(
                      "Ajouter un jury",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    textColor: Colors.white,
                    highlightColor: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, '/jury/add',
                          arguments: {'evenementId': widget.idEvent});
                    },
                  ),
                )),
              ],
            )),
      ],
    );
  }
}
