
import 'package:app_jury/components/CritereCard/critereCard.dart';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Critere.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class CritereByEventCard extends StatefulWidget {
  const CritereByEventCard({
    Key key,
    this.idEvent = 1,
    this.nomEvent = "",
    this.tap = defaultFunc,
  }) : super(key: key);

  final int idEvent;
  final String nomEvent;
  final Function tap;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _CritereByEventCardState createState() =>
      _CritereByEventCardState(idEvent, nomEvent, tap);
}

class _CritereByEventCardState extends State<CritereByEventCard> {
  _CritereByEventCardState(int idEvent, String nomEvent, Function tap) {
    idEvent = idEvent == null ? null : idEvent;
    nomEvent = nomEvent == null ? null : nomEvent;
    tap = tap == null ? null : tap;
  }

  int idEvent = 2;
  String nomEvent = "";
  Function tap;

  Future<List<Critere>> _fetchCritere() async {
    final response = await http
        .get('${Constant.addressIp}/criteres/evenement/${widget.idEvent}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsontolist = jsonDecode(response.body) as List;

      return jsontolist.map((tagJson) => Critere.fromJson(tagJson)).toList();
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
            height: 290,
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
                        child: Text("Liste des criteres",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                  height: 250,
                  child: FutureBuilder<List>(
                    future: _fetchCritere(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) =>
                                CritereCard(critere: snapshot.data[index]));
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
