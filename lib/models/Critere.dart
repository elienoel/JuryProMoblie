// To parse this JSON data, do
//
//     final critere = critereFromJson(jsonString);

import 'dart:convert';

Critere critereFromJson(String str) => Critere.fromJson(json.decode(str));

String critereToJson(Critere data) => json.encode(data.toJson());

class Critere {
    Critere({
        this.id,
        this.libelle,
        this.bareme,
        this.evenementid,
    });

    int id;
    String libelle;
    int bareme;
    int evenementid;

    factory Critere.fromJson(Map<String, dynamic> json) => Critere(
        id: json["id"],
        libelle: json["libelle"],
        bareme: json["bareme"],
        evenementid: json["evenementid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "bareme": bareme,
        "evenementid": evenementid,
    };
}
