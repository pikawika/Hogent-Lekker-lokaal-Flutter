class Cadeaubon {

  int bestelLijnId;
  String naam;
  double prijs;
  DateTime aanmaakDatum;
  int handelaarId;
  String emailadres;
  int geldigheid;
  String afbeelding;

  Cadeaubon({this.bestelLijnId, this.naam, this.prijs, this.aanmaakDatum, this.handelaarId, this.emailadres, this.geldigheid, this.afbeelding});

  factory Cadeaubon.fromJson(Map<String, dynamic> json) {
    return new Cadeaubon(
      bestelLijnId: json['bestelLijnId'],
      naam: json['naam'],
      prijs: json['prijs'],
      aanmaakDatum: DateTime.parse(json['aanmaakDatum']),
      handelaarId: json['handelaarId'],
      emailadres: json['emailadres'],
      geldigheid: json['geldigheid'],
      afbeelding: json['afbeelding']
    );
  }

  Map toJson() {
    return {
      "HandelaarId": handelaarId,
      "Geldigheid": geldigheid
    };
  }

  Cadeaubon.map(dynamic obj) {
    this.bestelLijnId = obj["bestelLijnId"];
    this.naam = obj["naam"];
    this.prijs = obj["prijs"];
    this.aanmaakDatum = DateTime.parse(obj["aanmaakDatum"]);
    this.handelaarId = obj["handelaarId"];
    this.emailadres = obj["emailadres"];
    this.geldigheid = obj["geldigheid"];
    this.afbeelding = obj["afbeelding"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["bestelLijnId"] = bestelLijnId;
    map["naam"] = naam;
    map["prijs"] = prijs;
    map["aanmaakDatum"] = aanmaakDatum.toString();
    map["handelaarId"] = handelaarId;
    map["emailadres"] = emailadres;
    map["geldigheid"] = geldigheid;
    map["afbeelding"] = afbeelding;

    return map;
  }

}