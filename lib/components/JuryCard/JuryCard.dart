import 'package:app_jury/models/jury.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JuryCard extends StatelessWidget {
  JuryCard({
    this.jury,
  });

  final Jury jury;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(padding: EdgeInsets.all(1)),
      Container(
        padding: EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1),
          border: Border.all(
            color: Colors.grey,
            width: 0.3,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(1),
              ),
              child: Text(
                jury.code,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(jury.nomComplet,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(jury.telephone,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            )))),
              ],
            )
          ],
        ),
      )
    ]);
  }
}
