import 'dart:convert';
import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/jury.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Connexion extends StatefulWidget {
  final int id;
  final int candidatid;
  final int evenementid;

  const Connexion({Key key, this.id, this.candidatid, this.evenementid})
      : super(key: key);

  @override
  _ConnexionState createState() => _ConnexionState(id, candidatid, evenementid);
}

class _ConnexionState extends State<Connexion> {
  _ConnexionState(int id, int candidatid, int evenementid) {
    id = id == null ? null : id;
    candidatid = candidatid == null ? null : candidatid;
    evenementid = evenementid == null ? null : evenementid;
  }

  int id;
  int candidatid;
  int evenementid;

  Future<Jury> _goToVoteJury;

  TextEditingController _codeController;

  Future<Jury> _getJury(String code) async {
    final response = await http.get('${Constant.addressIp}/jurys/code/$code');

    if (response.statusCode == 200) {
      Jury r = Jury.fromJson(jsonDecode(response.body));
      return r;
    } else {
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
      candidatid = arguments['candidatid'];
      evenementid = arguments['evenementid'];
      _reset();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: (_goToVoteJury == null)
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Connexion",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: this._codeController,
                    decoration: const InputDecoration(
                      labelText: "Code:",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Divider(),
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _goToVoteJury =
                                Request.getJury(_codeController.text);
                          });
                        },
                        color: Colors.orange,
                        child: const Text('CONNEXION'),
                      ),
                    ],
                  ),
                ],
              )
            : FutureBuilder<Jury>(
                future: _goToVoteJury,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${snapshot.data.nomComplet}",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "$candidatid",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(),
                          RaisedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/evenements',
                                    arguments: {
                                      'jury': snapshot.data,
                                    });
                              },
                              color: Colors.orange,
                              child: const Text('passer aux notes')),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ));
  }

  @override
  void initState() {
    super.initState();
    this._codeController = TextEditingController();
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
