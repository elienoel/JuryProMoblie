import 'package:app_jury/Requests/requests.dart';
import 'package:app_jury/components/EventCard/EventCard.dart';
import 'package:app_jury/components/EventCard/LargeEventCard.dart';
import 'package:app_jury/components/menu.dart';

import 'package:app_jury/models/evenement.dart';
import 'package:app_jury/models/jury.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Event extends StatefulWidget {
  const Event({
    Key key,
    this.jury,
  }) : super(key: key);

  final Jury jury;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  _EventState createState() => _EventState(jury);
}

class _EventState extends State<Event> {
  _EventState(Jury jury) {
    jury = jury == null ? null : jury;
  }

  Jury jury;

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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    //print(arguments['evenement']);
    if (arguments != null) {
      setState(() {
        jury = arguments['jury'];
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Menu(),
        (jury != null)
            ? Expanded(
                child: FutureBuilder<Evenement>(
                  future: Request.getOneEvent(jury.evenementid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return LargeEventCard(
                                evenement: snapshot.data,
                                jury: jury,
                              );
                    } else {
                      return Center(
                        child: Text("loading..."),
                      );
                    }
                  },
                ),
              )
            : Expanded(
                child: FutureBuilder<List<Evenement>>(
                  future: Request.getAllEvent(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) => EventCard(
                                evenement: snapshot.data[index]
                              ));
                    } else {
                      return Center(
                        child: Text("loading..."),
                      );
                    }
                  },
                ),
              )
      ],
    );
  }
}
