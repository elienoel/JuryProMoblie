import 'package:app_jury/constants/constant.dart';
import 'package:app_jury/models/Candidat.dart';
import 'package:app_jury/models/Critere.dart';
import 'package:app_jury/models/Groupe.dart';
import 'package:app_jury/models/Result.dart';
import 'package:app_jury/models/evenement.dart';
import 'package:app_jury/models/jury.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Request {
  static Future<List<Evenement>> getAllEvent() async {
    final response = await http.get('${Constant.addressIp}/evenements/');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;
      return jsontolist.map((tagJson) => Evenement.fromJson(tagJson)).toList();
    } else {
      print('Failed to load Evenement');
      // throw Exception('Failed to load Evenement');
      return null;
    }
  }

  static Future<Evenement> getOneEvent(int id) async {
    final response = await http.get('${Constant.addressIp}/evenements/$id');

    if (response.statusCode == 200) {
      return Evenement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Evenement');
    }
  }

  static Future<String> deleteEvent(int id) async {
    final response = await http.delete('${Constant.addressIp}/evenements/$id');

    if (response.statusCode == 200) {
      return "evenement supprimé";
    } else {
      throw Exception('Failed to load Evenement');
    }
  }

  static Future<Evenement> createOrUpdateEvent(int id, String type, String nom,
      String dateDebut, String dateFin, String base64Image) async {
    String uri;
    if (id == null) {
      uri = '${Constant.addressIp}/evenements/';
    } else {
      uri = '${Constant.addressIp}/evenements/$id';
    }

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'type': type,
        'nom': nom,
        'date_debut': dateDebut,
        'date_fin': dateFin,
        'image': base64Image,
      }),
    );
    // If the server did return a 201 CREATED response.
    if (response.statusCode == 200) {
      return Evenement.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }














   /* -------------------------------------------------------------------------------
   * ---------------------------------CANDIDAT API-------------------------------------
   * --------------------------------------------------------------------------------
  */


  static Future<List<Candidat>> getCandidatesByEvent(int idEvent) async {
    final response =
        await http.get('${Constant.addressIp}/candidats/evenement/$idEvent');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;

      return jsontolist.map((tagJson) => Candidat.fromJson(tagJson)).toList();
    } else {
      return null;
    }
  }

  static Future<Candidat> createOrUpdateCandidate(
      int id,
      String code,
      String nom,
      String prenom,
      String email,
      String telephone,
      String base64Image,
      int evenementid,
      Groupe groupe
      ) async {
    String uri;
    if (id == null) {
      uri = '${Constant.addressIp}/candidats/';
    } else {
      uri = '${Constant.addressIp}/candidats/$id';
    }

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'code': code,
        'nom': nom,
        'prenom': prenom,
        'photo': base64Image,
        'email': email,
        'telephone': telephone,
        'evenementid': evenementid,
      }),
    );
    // If the server did return a 201 CREATED response.
    if (response.statusCode == 200) {
      Candidat result = Candidat.fromJson(jsonDecode(response.body));
        if (groupe != null && id ==null) {
          Future<bool> addCandidatToGroup;
          addCandidatToGroup = Request.addCandidateToGroup(groupe.id, result.id);
          print("candidat ajouter au groupe");
        }
        return result;
    } else {
      return null;
    }
  }


  static Future<String> deleteCandidate(int id) async {
    final response = await http.delete('${Constant.addressIp}/candidats/$id');

    if (response.statusCode == 200) {
      return "Candidat supprimé";
    } else {
      return "Erreur";
    }
  }




























  /* -------------------------------------------------------------------------------
   * ---------------------------------GROUPE API-------------------------------------
   * --------------------------------------------------------------------------------
  */

  static Future<List<Groupe>> getGroupsByEvent(int idEvent) async {
    final response =
        await http.get('${Constant.addressIp}/groupes/evenement/$idEvent');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;

      return jsontolist.map((tagJson) => Groupe.fromJson(tagJson)).toList();
    } else {
      return null;
    }
  }

  static Future<Groupe> createOrUpdateGroup(int id, String code, String nom, String photo,
       int evenementid) async {
    String uri;
    if (id == null) {
      uri = '${Constant.addressIp}/groupes/';
    } else {
      uri = '${Constant.addressIp}/groupes/$id';
    }

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'code': code,
        'nom': nom,
        'photo': photo,
        'evenementid': evenementid,
      }),
    );
    // If the server did return a 201 CREATED response.
    if (response.statusCode == 200) {
      return Groupe.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<String> deleteGroup(int id) async {
    final response = await http.delete('${Constant.addressIp}/groupes/$id');

    if (response.statusCode == 200) {
      return "Candidat supprimé";
    } else {
      return "Erreur";
    }
  }


  static Future<bool> addCandidateToGroup(int groupid, int candidatid) async {
    final response = await http.post(
      '${Constant.addressIp}/groupecandidats',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'groupe_id': groupid,
        'candidat_id': candidatid,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }














   /* -------------------------------------------------------------------------------
   * ---------------------------------JURY API-------------------------------------
   * --------------------------------------------------------------------------------
  */
  static Future<List<Jury>> getJuryByEvent(int idEvent) async {
    final response =
        await http.get('${Constant.addressIp}/jurys/evenement/$idEvent');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;
      return jsontolist.map((tagJson) => Jury.fromJson(tagJson)).toList();
    } else {
      print('Failed to load Evenement');
      return null;
    }
  }

  static Future<Jury> createOrUpdateJury(
      int id, String code, String nomComplet, String telephone,
      int evenementid) async {
    String uri;
    if (id == null) {
      uri = '${Constant.addressIp}/jurys/';
    } else {
      uri = '${Constant.addressIp}/jurys/$id';
    }

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'code': code,
        'nom_complet': nomComplet,
        'telephone': telephone,
        'evenementid': evenementid,
      }),
    );
    // If the server did return a 201 CREATED response.
    if (response.statusCode == 200) {
      return Jury.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<Jury> getJury(String code) async {
    final response = await http.get('${Constant.addressIp}/jurys/code/$code');

    if (response.statusCode == 200) {
      Jury r = Jury.fromJson(jsonDecode(response.body));
      return r;
    } else {
      return null;
    }
  }

  static Future<String> deleteJury(int id) async {
    final response = await http.delete('${Constant.addressIp}/jury/$id');

    if (response.statusCode == 200) {
      return "Jury supprimé";
    } else {
      return "Erreur";
    }
  }





















 /* -------------------------------------------------------------------------------
   * ---------------------------------CRITERE API-------------------------------------
   * --------------------------------------------------------------------------------
  */
  static Future<List<Critere>> getCritereByEvent(int idEvent) async {
    final response =
        await http.get('${Constant.addressIp}/criteres/evenement/$idEvent');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;
      return jsontolist.map((tagJson) => Critere.fromJson(tagJson)).toList();
    } else {
      print('Critere introuvable');
      return null;
    }
  }


  static Future<Critere> createOrUpdateCritere(int id, String libelle, int bareme, int evenementid) async {
    String uri;
    if (id == null) {
      uri = '${Constant.addressIp}/criteres/';
    } else {
      uri = '${Constant.addressIp}/criteres/$id';
    }

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'libelle': libelle,
          'bareme': bareme,
          'evenementid': evenementid,
      }),
    );
    // If the server did return a 201 CREATED response.
    if (response.statusCode == 200) {
      return Critere.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<String> deleteCritere(int id) async {
    final response = await http.delete('${Constant.addressIp}/critere/$id');

    if (response.statusCode == 200) {
      return "Critere supprimé";
    } else {
      return "Erreur";
    }
  }

  static Future<bool> saveNote(int evenementid, int juryid, int candidatid,
      int critereid, int noteValue, String commentaire, bool individuel) async {
    var response;
    if (individuel) {
      response = await http.post(
        '${Constant.addressIp}/votescandidat',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "juryid": juryid,
          "evenementid": evenementid,
          "critereid": critereid,
          "candidatid": candidatid,
          "note": noteValue,
          "commentaires": commentaire
        }),
      );
    } else {
      response = await http.post(
        '${Constant.addressIp}/votesgroupe',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "juryid": juryid,
          "evenementid": evenementid,
          "critereid": critereid,
          "groupeid": candidatid,
          "note": noteValue,
          "commentaires": commentaire
        }),
      );
    }
    // VoteCandidat.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }




















   /* -------------------------------------------------------------------------------
   * ---------------------------------REULTATS API-------------------------------------
   * --------------------------------------------------------------------------------
  */


  static Future<List<Result>> getResultByJury(int idEvent, int idJury) async {
    final response =
        await http.get('${Constant.addressIp}/votesjury/$idEvent/$idJury');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;
      print(jsontolist.map((tagJson) => Result.fromJson(tagJson)).toList());
      return jsontolist.map((tagJson) => Result.fromJson(tagJson)).toList();
    } else {
      print('Resultat introuvable');
      return null;
    }
  }


  static Future<List<Result>> getResultForGroupByJury(int idEvent, int idJury) async {
    final response =
        await http.get('${Constant.addressIp}/votesgroupe/votesjury/$idEvent/$idJury');

    if (response.statusCode == 200) {
      var jsontolist = jsonDecode(response.body) as List;
      print(jsontolist.map((tagJson) => Result.fromJson(tagJson)).toList());
      return jsontolist.map((tagJson) => Result.fromJson(tagJson)).toList();
    } else {
      print('Resultat introuvable');
      return null;
    }
  }







  
}
