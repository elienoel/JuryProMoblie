// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class NoteInput extends StatefulWidget {
//   @override
//   _NoteInputState createState() => _NoteInputState();
// }

// class _NoteInputState extends State<NoteInput> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           Padding(padding: EdgeInsets.all(5)),
//           Container(
//             padding: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               color: Colors.orange[50],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 100,
//                       child: Image.asset(
//                         "assets/images/profil.jpg",
//                         height: 60,
//                       ),
//                     ),
//                     Text(
//                       "Yao kouame Elie-noel",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       "15/20",
//                       style: TextStyle(
//                         fontSize: 30,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                         child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: FlatButton(
//                         height: 30,
//                         color: Colors.orangeAccent,
//                         child: Text(
//                           "Noter",
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.white,
//                           ),
//                         ),
//                         textColor: Colors.white,
//                         highlightColor: Colors.black,
//                         onPressed: () {
//                           showDialog<String>(
//                             context: context,
//                             builder: (BuildContext context) => SimpleDialog(
//                               title: const Text('Attribuer une note'),
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 5),
//                                   child: FlatButton(
//                                       height: 40,
//                                       color: Colors.orangeAccent,
//                                       onPressed: () {},
//                                       child: Text("Noter")),
//                                 )
//                               ],
//                             ),
//                           ).then((returnVal) {
//                             if (returnVal != null) {}
//                           });
//                         },
//                       ),
//                     )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NoteInput extends StatelessWidget {
//   NoteInput(
//       {this.critere = "label",
//       this.note,
//       this.bareme,
//       this.idcandidat,
//       this.idjury});
//   final String critere;
//   final int note;
//   final int bareme;
//   final int idcandidat;
//   final int idjury;

//   String valueChoose;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(left: 5),
//                 width: 100,
//                 child: Text("$critere :"),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, right: 10),
//                 child: Container(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey, width: 1)),
//                   child: DropdownButton(
//                     hint: Text("note"),
//                     icon: Icon(Icons.arrow_drop_down),
//                     iconSize: 20,
//                     value: valueChoose,
//                     onChanged: (newvalue) {
//                       setState(() {
//                         valueChoose = newvalue;
//                       });
//                     },
//                     items: [
//                       DropdownMenuItem(value: 1, child: Text("1")),
//                       DropdownMenuItem(value: 2, child: Text("2")),
//                       DropdownMenuItem(value: 3, child: Text("3")),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
