class Cadeaubon {

  int _bestelLijnId;
  String _naam;
  double _prijs;
  DateTime _aanmaakDatum;
  int _handelaarId;
  String _emailadres;
  int _geldigheid;

  Cadeaubon(this._bestelLijnId, this._naam, this._prijs, this._aanmaakDatum, this._handelaarId, this._emailadres, this._geldigheid);

  int get bestelLijnId => _bestelLijnId;
  String get naam => _naam;
  double get prijs => _prijs;
  DateTime get aanmaakDatum => _aanmaakDatum;
  int get handelaarId => _handelaarId;
  String get emailadres => _emailadres;
  int get geldigheid => _geldigheid;

}