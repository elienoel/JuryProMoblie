// To parse this JSON data, do
//
//     final groupe = groupeFromJson(jsonString);

import 'dart:convert';

Groupe groupeFromJson(String str) => Groupe.fromJson(json.decode(str));

String groupeToJson(Groupe data) => json.encode(data.toJson());

class Groupe {
    Groupe({
        this.id,
        this.code,
        this.nom,
        this.photo,
        this.evenementid,
    });

    int id;
    String code;
    String nom;
    String photo;
    int evenementid;

    factory Groupe.fromJson(Map<String, dynamic> json) => Groupe(
        id: json["id"],
        code: json["code"],
        nom: json["nom"],
        photo: json["photo"],
        evenementid: json["evenementid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "nom": nom,
        "photo": photo,
        "evenementid": evenementid,
    };
}
