class Handelaar {

  int handelaarId;
  String btwNummer;
  String beschrijving;
  String emailadres;
  String naam;

  Handelaar({this.handelaarId, this.btwNummer, this.beschrijving, this.emailadres, this.naam});

  factory Handelaar.fromJson(Map<String, dynamic> json) {
    return new Handelaar(
      handelaarId: json['handelaarId'],
      btwNummer: json['btW_Nummer'],
      beschrijving: json['beschrijving'],
      emailadres: json['emailadres'],
      naam: json['naam']
    );
  }

  Handelaar.map(dynamic obj) {
    this.handelaarId = obj["handelaarId"];
    this.btwNummer = obj["btwNummer"];
    this.beschrijving = obj["beschrijving"];
    this.emailadres = obj["emailadres"];
    this.naam = obj["naam"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["handelaarId"] = handelaarId;
    map["btwNummer"] = btwNummer;
    map["beschrijving"] = beschrijving;
    map["emailadres"] = emailadres;
    map["naam"] = naam;

    return map;
  }

}