class Handelaar {

  final int handelaarId;
  final String btwNummer;
  final String beschrijving;
  final String emailadres;
  final String naam;

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

}