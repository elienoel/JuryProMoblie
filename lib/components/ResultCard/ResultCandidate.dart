import 'dart:convert';
import 'package:app_jury/models/Result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ResultCandidate extends StatefulWidget {
  final int juryid;
  final Result result;

  const ResultCandidate({Key key, this.juryid, this.result}) : super(key: key);

  @override
  _ResultCandidateState createState() => _ResultCandidateState(juryid, result);
}

class _ResultCandidateState extends State<ResultCandidate> {
  _ResultCandidateState(int juryid, Result result) {
    juryid = juryid == null ? null : juryid;
    result = result == null ? null : result;
  }

  int juryid;
  Result result;
  String commentaire;

  @override
  Widget build(BuildContext context) {
    result = widget.result;

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
                        Base64Codec().decode(result.photo),
                        fit: BoxFit.fill,
                      ),
                      height: 60,
                    ),
                    Text(
                      "${result.nom} ${result.prenom}",
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
                      "${result.total}/${result.totalbareme}",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 22,
                        initialRating: ((5 * result.total) / result.totalbareme)
                            .roundToDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                    ),

                    // Container(
                    //     child: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //   child: FlatButton(
                    //     height: 30,
                    //     color: Colors.orangeAccent,
                    //     child: Text(
                    //       "Noter",
                    //       style: TextStyle(
                    //         fontSize: 10,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     textColor: Colors.white,
                    //     highlightColor: Colors.black,
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, '/connexion',
                    //           arguments: {
                    //             'resultid': result.id,
                    //           });
                    //     },
                    //   ),
                    // )),
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
