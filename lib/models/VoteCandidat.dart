// To parse this JSON data, do
//
//     final voteCandidat = voteCandidatFromJson(jsonString);

import 'dart:convert';

VoteCandidat voteCandidatFromJson(String str) => VoteCandidat.fromJson(json.decode(str));

String voteCandidatToJson(VoteCandidat data) => json.encode(data.toJson());

class VoteCandidat {
    VoteCandidat({
        this.id,
        this.evenementid,
        this.note,
        this.commentaires,
        this.candidatId,
        this.juryId,
        this.critereId,
    });

    int id;
    int evenementid;
    int note;
    String commentaires;
    int candidatId;
    int juryId;
    int critereId;

    factory VoteCandidat.fromJson(Map<String, dynamic> json) => VoteCandidat(
        id: json["id"],
        evenementid: json["evenementid"],
        note: json["note"],
        commentaires: json["commentaires"],
        candidatId: json["candidat_id"],
        juryId: json["jury_id"],
        critereId: json["critere_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "evenementid": evenementid,
        "note": note,
        "commentaires": commentaires,
        "candidat_id": candidatId,
        "jury_id": juryId,
        "critere_id": critereId,
    };
}
