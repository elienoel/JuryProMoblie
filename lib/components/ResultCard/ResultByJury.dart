import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/components/ResultCard/ResultCandidate.dart';
import 'package:app_jury/models/Result.dart';
import 'package:app_jury/models/evenement.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultByJury extends StatefulWidget {
  const ResultByJury({
    Key key,
    this.evenement,
    this.juryid,
  }) : super(key: key);

  final Evenement evenement;
  final int juryid;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _ResultByJuryState createState() => _ResultByJuryState(evenement, juryid);
}

class _ResultByJuryState extends State<ResultByJury> {
  _ResultByJuryState(Evenement evenement, int juryid) {
    evenement = evenement == null ? null : evenement;
    juryid = juryid == null ? null : juryid;
  }

  Evenement evenement;
  int juryid;

  @override
  Widget build(BuildContext context) {
    print(widget.juryid);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: EdgeInsets.all(1),
            height: 285,
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
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text("MES VOTES",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                  height: 240,
                  child: FutureBuilder<List<Result>>(
                    future:(widget.evenement.type=="INDIVIDUEL")
                    ? Request.getResultByJury(
                        widget.evenement.id, widget.juryid)
                        :
                        Request.getResultForGroupByJury(
                        widget.evenement.id, widget.juryid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => ResultCandidate(
                                  result: snapshot.data[index],
                                  juryid: widget.juryid,
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
