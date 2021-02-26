// To parse this JSON data, do
//
//     final candidat = candidatFromJson(jsonString);

import 'dart:convert';

Candidat candidatFromJson(String str) => Candidat.fromJson(json.decode(str));

String candidatToJson(Candidat data) => json.encode(data.toJson());

class Candidat {
    Candidat({
        this.id,
        this.code,
        this.nom,
        this.prenom,
        this.photo,
        this.email,
        this.telephone,
        this.evenementid,
    });

    int id;
    String code;
    String nom;
    String prenom;
    String photo;
    String email;
    String telephone;
    int evenementid;

    factory Candidat.fromJson(Map<String, dynamic> json) => Candidat(
        id: json["id"],
        code: json["code"],
        nom: json["nom"],
        prenom: json["prenom"],
        photo: json["photo"],
        email: json["email"],
        telephone: json["telephone"],
        evenementid: json["evenementid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "nom": nom,
        "prenom": prenom,
        "photo": photo,
        "email": email,
        "telephone": telephone,
        "evenementid": evenementid,
    };
}
