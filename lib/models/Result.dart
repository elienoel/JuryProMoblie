// To parse this JSON data, do
//
//     final result = resultFromJson(jsonString);

import 'dart:convert';

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
    Result({
        this.id,
        this.totalbareme,
        this.votant,
        this.total,
        this.nom,
        this.prenom,
        this.photo,
    });

    int id;
    int totalbareme;
    int votant;
    int total;
    String nom;
    String prenom;
    String photo;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        totalbareme: json["totalbareme"],
        votant: json["votant"],
        total: json["total"],
        nom: json["nom"],
        prenom: json["prenom"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "totalbareme": totalbareme,
        "votant": votant,
        "total": total,
        "nom": nom,
        "prenom": prenom,
        "photo": photo,
    };
}
