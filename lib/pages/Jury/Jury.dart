
import 'package:app_jury/components/JuryCard/JuryByEventCard.dart';
import 'package:app_jury/components/menu.dart';
import 'package:app_jury/constants/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Jury extends StatefulWidget {
  @override
  _JuryState createState() => _JuryState();
}

class _JuryState extends State<Jury> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List> _fetchEvenement() async {
    final response = await http.get('${Constant.addressIp}/evenements/');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/evenements/add');
        },
        child: const Icon(Icons.add),
      ),
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

  Column body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Menu(),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          child: FutureBuilder<List>(
            future: _fetchEvenement(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => JuryByEventCard(
                          idEvent: snapshot.data[index]["id"],
                          nomEvent: snapshot.data[index]["nom"],
                        ));
              } else {
                return Center(
                  child: Text("loading..."),
                );
              }
            },
          ),
        ))
      ],
    );
  }
}
