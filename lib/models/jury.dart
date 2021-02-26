// To parse this JSON data, do
//
//     final jury = juryFromJson(jsonString);

import 'dart:convert';

Jury juryFromJson(String str) => Jury.fromJson(json.decode(str));

String juryToJson(Jury data) => json.encode(data.toJson());

class Jury {
    Jury({
        this.id,
        this.code,
        this.nomComplet,
        this.telephone,
        this.evenementid,
    });

    int id;
    String code;
    String nomComplet;
    String telephone;
    int evenementid;

    factory Jury.fromJson(Map<String, dynamic> json) => Jury(
        id: json["id"],
        code: json["code"],
        nomComplet: json["nom_complet"],
        telephone: json["telephone"],
        evenementid: json["evenementid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "nom_complet": nomComplet,
        "telephone": telephone,
        "evenementid": evenementid,
    };
}
