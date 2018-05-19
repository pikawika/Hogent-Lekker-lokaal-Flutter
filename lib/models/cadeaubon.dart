class Cadeaubon {

  final int bestelLijnId;
  final String naam;
  final double prijs;
  final DateTime aanmaakDatum;
  final int handelaarId;
  final String emailadres;
  final int geldigheid;

  Cadeaubon({this.bestelLijnId, this.naam, this.prijs, this.aanmaakDatum, this.handelaarId, this.emailadres, this.geldigheid});

  factory Cadeaubon.fromJson(Map<String, dynamic> json) {
    return new Cadeaubon(
      bestelLijnId: json['bestelLijnId'],
      naam: json['naam'],
      prijs: json['prijs'],
      aanmaakDatum: DateTime.parse(json['aanmaakDatum']),
      handelaarId: json['handelaarId'],
      emailadres: json['emailadres'],
      geldigheid: json['geldigheid']
    );
  }

}