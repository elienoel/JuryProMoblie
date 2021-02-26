// To parse this JSON data, do
//
//     final evenement = evenementFromJson(jsonString);

import 'dart:convert';

Evenement evenementFromJson(String str) => Evenement.fromJson(json.decode(str));

String evenementToJson(Evenement data) => json.encode(data.toJson());

class Evenement {
  Evenement({
    this.id,
    this.type,
    this.nom,
    this.dateDebut,
    this.dateFin,
    this.image,
    this.participant,
  });

  int id;
  String type;
  String nom;
  DateTime dateDebut;
  DateTime dateFin;
  String image;
  int participant;

  factory Evenement.fromJson(Map<String, dynamic> json) => Evenement(
        id: json["id"],
        type: json["type"],
        nom: json["nom"],
        dateDebut: DateTime.parse(json["date_debut"]),
        dateFin: DateTime.parse(json["date_fin"]),
        image: json["image"],
        participant: json["participant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "nom": nom,
        "date_debut":
            "${dateDebut.year.toString().padLeft(4, '0')}-${dateDebut.month.toString().padLeft(2, '0')}-${dateDebut.day.toString().padLeft(2, '0')}",
        "date_fin":
            "${dateFin.year.toString().padLeft(4, '0')}-${dateFin.month.toString().padLeft(2, '0')}-${dateFin.day.toString().padLeft(2, '0')}",
        "image": image,
        "participant": participant,
      };
}
