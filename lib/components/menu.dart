import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Menu extends StatefulWidget {
  // Menu(String s, {this.page=""});

  // String page;


  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<String> menuItems = [
    "Evenements",
    "Votes",
    "Resultat",
  ];
  int selectedIndex = 0;

  String link = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menuItems.length,
            itemBuilder: (context, index) => buildmenuItem(index)),
      ),
    );
  }

  Widget buildmenuItem(int index) {
    return GestureDetector(
      onTap: () {
        link = menuItems[index].toLowerCase();
        Navigator.pushNamed(context, '/$link');
        setState(() {

          selectedIndex = index;
        });
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                menuItems[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? Colors.black : Colors.grey,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: 2,
                width: 30,
                color:
                    selectedIndex == index ? Colors.black : Colors.transparent,
              )
            ],
          )),
    );
  }
}
