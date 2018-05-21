import 'package:flutter/material.dart';

import '../../data/database_helper.dart';
import '../../models/cadeaubon.dart';

class BonPage extends StatefulWidget {
  static String tag = 'bon-page';
  @override
  _BonPageState createState() => new _BonPageState();
}

class _BonPageState extends State<BonPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final db = new DatabaseHelper();
  Cadeaubon _cadeaubon = new Cadeaubon(naam: "Naam van de cadeaubon", prijs: 60.00);

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      duration: Duration(seconds: 4),
    ));
  }

  void haalCadeaubonOp() async {
    Cadeaubon cadeaubon = await db.getCadeaubon();
    setState(() {
          this._cadeaubon = cadeaubon;
    });
  }

  String maakAfbeeldingURL() {
    return "https://testlekkerlokaal.azurewebsites.net/" + _cadeaubon.afbeelding;
  }

  void verifieerCadeaubon() {
    switch(_cadeaubon.geldigheid) {
      case 0:
        
        //if (_cadeaubon.aanmaakDatum.add(new Duration(days: 365)) <= new DateTime.now())
        break;
      case 1:
        _showSnackBar("Deze cadeaubon werd reeds ongeldig verklaard.");
        break;
      case 2:
        _showSnackBar("Deze cadeaubon is meer dan één jaar oud en daardoor niet meer bruikbaar.");
        break;
      case 3:
        _showSnackBar("Deze cadeaubon werd reeds gebruikt.");
        break;
      default:
        _showSnackBar("Er is een fout opgetreden bij het verifiëren van de gegevens.");
    }
  }

  @override
  initState() {
    haalCadeaubonOp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final afbeelding = new Image.network(
      maakAfbeeldingURL()
    );

    final naamBon = Text(
      _cadeaubon.naam,
      textAlign: TextAlign.center,
    );

    final bedragBon = Text(
      'Bedrag: € ' + _cadeaubon.prijs.toString(),
      textAlign: TextAlign.center,
    );

    final geldigTotBon = Text(
      'Geldig tot ' + _cadeaubon.aanmaakDatum.add(new Duration(days: 365)).toString(),
      textAlign: TextAlign.center,
    );

    final valideerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            _showSnackBar("pistole");
          },
          color: Colors.lightBlueAccent,
          child:
              Text('Verifieer de cadeaubon', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final scanButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.lightBlueAccent,
          child:
              Text('Ga terug naar scannen', style: TextStyle(color: Colors.white)),
        ),
      ),
    );


    return Scaffold(
      appBar: new AppBar(
        title:
            new Text("Lekker Lokaal", style: TextStyle(color: Colors.white)),
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            afbeelding,
            SizedBox(height: 10.0),
            naamBon,
            SizedBox(height: 5.0),
            bedragBon,
            SizedBox(height: 5.0),
            geldigTotBon,
            valideerButton,
            scanButton,
          ],
        ),
      ),
    );

  }
}