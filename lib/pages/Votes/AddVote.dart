import 'dart:convert';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Candidat.dart';
import 'package:app_jury/models/Critere.dart';
import 'package:app_jury/models/VoteCandidat.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddVote extends StatefulWidget {
  final int juryid;
  final int candidatid;
  final int evenementid;

  const AddVote({Key key, this.juryid, this.candidatid, this.evenementid})
      : super(key: key);

  @override
  _AddVoteState createState() => _AddVoteState(juryid, candidatid, evenementid);
}

class _AddVoteState extends State<AddVote> {
  _AddVoteState(int juryid, int candidatid, int evenementid) {
    juryid = juryid == null ? null : juryid;
    candidatid = candidatid == null ? null : candidatid;
    evenementid = evenementid == null ? null : evenementid;
  }

  int juryid;
  int candidatid;
  int evenementid;

  Map _note = {};

  bool _noteSend = false;

  TextEditingController _codeController;

  Future<VoteCandidat> saveNote(int critereid, int noteValue) async {
    final response = await http.post(
      '${Constant.addressIp}/votescandidat',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "juryid": juryid,
        "evenementid": evenementid,
        "critereid": critereid,
        "candidatid": candidatid,
        "note": noteValue,
        "commentaires": "nothing"
      }),
    );
    // If the server did return a 201 CREATED response.
    if (response.statusCode == 200) {
      print("envoyé");
      return VoteCandidat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('la creation de evenement a echoué.');
    }
  }

  Future<List<Critere>> _fetchCritere() async {
    final response = await http
        .get('${Constant.addressIp}/criteres/evenement/${evenementid}');

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
    return Scaffold(
      appBar: buildAppBar(),
      body: body(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/left-arrow.svg"),
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/loupe.svg",
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add.svg",
            color: Colors.black,
          ),
          onPressed: () {
            _note.forEach((key, value) {
              int critere = key;
              int valeur = value;
              saveNote(critere, valeur);
              Navigator.pushNamed(context, '/evenements/id',
                  arguments: {'id': evenementid});
            });
          },
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Container body(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    //print(arguments['evenement']);
    if (arguments != null) if (arguments != null) {
      juryid = arguments['juryid'];
      candidatid = arguments['candidatid'];
      evenementid = arguments['evenementid'];
      _reset();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List>(
          future: _fetchCritere(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${snapshot.data[index].libelle} :",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        child: RatingBar.builder(
                          itemSize: 25,
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            int idm = snapshot.data[index].id;

                            _note[idm] =
                                ((snapshot.data[index].bareme * rating) / 5)
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
                ),
              );
            } else {
              return Center(
                child: Text("loading..."),
              );
            }
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    this._codeController = TextEditingController();
    _note = {};
    _reset();
  }

  void _reset({bool resetControllers = true}) {
    setState(() {
      if (resetControllers) {
        this._codeController.text = "";
      }
      evenementid = evenementid;
      candidatid = candidatid;
    });
  }
}

class CritereNoteCard extends StatelessWidget {
  CritereNoteCard({
    this.critere,
  });
  final Critere critere;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${critere.libelle} :",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              child: RatingBar.builder(
                itemSize: 25,
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// RaisedButton(
//                                 onPressed: () {
//                                   note.forEach((key, value) {
//                                     int critere=key;
//                                     int valeur=value;
//                                     saveNote(critere,valeur);
//                                   });
//                                 },
//                                 color: Colors.orange,
//                                 child: const Text('VALIDER'))
