import 'package:app_jury/components/CandidateEtGroupCard/GroupeCard.dart';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Groupe.dart';
import 'package:app_jury/models/evenement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class GroupeByEventCard extends StatefulWidget {
  const GroupeByEventCard({
    Key key,
    this.evenement,
    this.tap = defaultFunc,
  }) : super(key: key);

  final Evenement evenement;
  final Function tap;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _GroupeByEventCardState createState() =>
      _GroupeByEventCardState(evenement, tap);
}

class _GroupeByEventCardState extends State<GroupeByEventCard> {
  _GroupeByEventCardState(Evenement evenement, Function tap) {
    evenement = evenement == null ? null : evenement;
    tap = tap == null ? null : tap;
  }

  Evenement evenement;
  Function tap;

  Future<List<Groupe>> _fetchGroupe() async {
    final response = await http
        .get('${Constant.addressIp}/groupes/evenement/${widget.evenement.id}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsontolist = jsonDecode(response.body) as List;

      return jsontolist.map((tagJson) => Groupe.fromJson(tagJson)).toList();
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
                        child: Text("Liste des groupes participants",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                  height: 348,
                  child: FutureBuilder<List>(
                    future: _fetchGroupe(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => GroupeCard(
                                  groupe: snapshot.data[index],
                                  evenement: widget.evenement,
                                ));
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
