import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/jury.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// ignore: must_be_immutable

class ReadJury extends StatefulWidget {
  const ReadJury({Key key, this.id = 1}) : super(key: key);

  final int id;

  @override
  _ReadJuryState createState() => _ReadJuryState(id);
}

class _ReadJuryState extends State<ReadJury> {
  _ReadJuryState(int id) {
    id = id == null ? null : id;
  }

  int id;

  Future<String> _deleteEvent;

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
            "assets/icons/add.svg",
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add-user.svg",
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/add-group.svg",
            color: Colors.black,
          ),
          onPressed: () {},
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
      id = arguments['id'];
    }

    Future<Jury> fetchJury() async {
      final response =
          await http.get('${Constant.addressIp}/evenements/$id');

      if (response.statusCode == 200) {
        return Jury.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load Jury');
      }
    }

    Future<String> deleteJury() async {
      final response =
          await http.delete('${Constant.addressIp}/criteres/$id');

      if (response.statusCode == 200) {
        return "evenement supprimé";
      } else {
        throw Exception('Failed to load Jury');
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(1),
      child: (_deleteEvent == null)
          ? FutureBuilder<Jury>(
              future: fetchJury(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: <Widget>[
                           RaisedButton(
                            onPressed: () {
                              setState(() {
                                _deleteEvent = deleteJury();
                              });
                            },
                            color: Colors.orange,
                            child: const Text('Supprimer')),
                        RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/evenements/add',
                                  arguments: {
                                    'id': snapshot.data.id,
                                    'code': snapshot.data.code,
                                    'nomComplet': snapshot.data.nomComplet,
                                    'telephone': snapshot.data.telephone,
                                    'evenementid': snapshot.data.evenementid,
                                  });
                            },
                            color: Colors.orange,
                            child: const Text('Modifier')),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              snapshot.data.code,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Text(
                              snapshot.data.nomComplet,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ]);
                  
                
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : FutureBuilder<String>(
              future: _deleteEvent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                        child: Text(snapshot.data),
                      ),
                      RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/evenements');
                          },
                          color: Colors.orange,
                          child:
                              const Text("Retourner a la liste d'evenement")),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
