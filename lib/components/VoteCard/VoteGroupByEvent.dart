import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/components/VoteCard/VoteCandidate.dart';
import 'package:app_jury/components/VoteCard/VoteGroup.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteGroupByEvent extends StatefulWidget {
  const VoteGroupByEvent({
    Key key,
    this.evenementid = 1,
    this.juryid,
  }) : super(key: key);

  final int evenementid;
  final int juryid;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _VoteGroupByEventState createState() =>
      _VoteGroupByEventState(evenementid, juryid);
}

class _VoteGroupByEventState extends State<VoteGroupByEvent> {
  _VoteGroupByEventState(int evenementid, int juryid) {
    evenementid = evenementid == null ? null : evenementid;
    juryid = juryid == null ? null : juryid;
  }

  int evenementid;
  int juryid;

  @override
  Widget build(BuildContext context) {
    print(widget.juryid);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: EdgeInsets.all(1),
            height: 390,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text("VOTER LES DIFFERENTS GROUPES",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                  height: 340,
                  child: FutureBuilder<List>(
                    future: Request.getGroupsByEvent(widget.evenementid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => VoteGroup(
                                  groupe: snapshot.data[index],
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
