import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:date_format/date_format.dart';

import '../../data/database_helper.dart';
import '../../models/cadeaubon.dart';
import '../../models/handelaar.dart';
import 'bon_presenter.dart';

class BonPage extends StatefulWidget {
  static String tag = 'bon-page';
  @override
  _BonPageState createState() => new _BonPageState();
}

class _BonPageState extends State<BonPage> implements BonPageContract {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final db = new DatabaseHelper();
  Cadeaubon _cadeaubon =
      new Cadeaubon(naam: "Naam van de cadeaubon", prijs: 60.00);
  Handelaar _handelaar = new Handelaar(emailadres: "lekkerlokaalst@gmail.com");

  BonPagePresenter _presenter;

  _BonPageState() {
    _presenter = new BonPagePresenter(this);
  }

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

  void haalHandelaarOp() async {
    Handelaar handelaar = await db.getHandelaar();
    setState(() {
      this._handelaar = handelaar;
    });
  }

  String maakAfbeeldingURL() {
    return "https://lekkerlokaalbralenbre.azurewebsites.net/" +
        _cadeaubon.afbeelding;
  }

  String maakDatum() {
    return formatDate(_cadeaubon.aanmaakDatum.add(new Duration(days: 365)),
        [dd, '/', mm, '/', yyyy]);
  }

  void verifieerCadeaubon() {
    switch (_cadeaubon.geldigheid) {
      case 0:
        if (_cadeaubon.aanmaakDatum
                .add(new Duration(days: 365))
                .millisecondsSinceEpoch <=
            new DateTime.now().millisecondsSinceEpoch) {
          _cadeaubonNietValideerbaarKeuzemenu(
              "Deze cadeaubon is meer dan één jaar oud en daardoor niet meer geldig.");
        } else if (_cadeaubon.emailadres != _handelaar.emailadres &&
            _cadeaubon.emailadres != "generiek@gmail.com")
          _cadeaubonNietValideerbaarKeuzemenu(
              "De ingescande QR-code is niet bruikbaar in deze winkel.");
        else {
          _cadeaubonValideerbaarKeuzemenu();
        }
        break;
      case 1:
        _cadeaubonNietValideerbaarKeuzemenu(
            "Deze cadeaubon werd ongeldig verklaard.");
        break;
      case 2:
        _cadeaubonNietValideerbaarKeuzemenu(
            "Deze cadeaubon is meer dan één jaar oud en daardoor niet meer bruikbaar.");
        break;
      case 3:
        _cadeaubonNietValideerbaarKeuzemenu(
            "Deze cadeaubon werd al eens gebruikt.");
        break;
      default:
        _cadeaubonNietValideerbaarKeuzemenu(
            "Er is een fout opgetreden bij het verifiëren van de gegevens.");
    }
  }

  Future<Null> _cadeaubonValideerbaarKeuzemenu() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Bon is valideerbaar',
              style: TextStyle(color: Colors.green)),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                    'U staat op het punt om deze cadeaubon te valideren. Bent u zeker dat u de volledige waarde (€ ' +
                        _cadeaubon.prijs.toStringAsFixed(2) +
                        ') wilt gebruiken?'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ja'),
              onPressed: () {
                if (_cadeaubon.emailadres == "generiek@gmail.com")
                  _cadeaubon.handelaarId = _handelaar.handelaarId;
                _cadeaubon.geldigheid = 3;
                _presenter.doValidatie(_cadeaubon);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Nee'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _cadeaubonNietValideerbaarKeuzemenu(String boodschap) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Bon is niet valideerbaar',
              style: TextStyle(color: Colors.red)),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(boodschap),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Oke'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  initState() {
    super.initState();
    haalCadeaubonOp();
    haalHandelaarOp();
  }

  @override
  Widget build(BuildContext context) {
    final afbeelding = new Image.network(maakAfbeeldingURL());

    final naamBon = Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Text(
        _cadeaubon.naam,
        style: TextStyle(fontSize: 24.0),
        textAlign: TextAlign.center,
      ),
    );

    final bedragBon = Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Text(
        'Waarde v/d bon: € ' + _cadeaubon.prijs.toStringAsFixed(2),
        style: TextStyle(fontSize: 24.0),
        textAlign: TextAlign.center,
      ),
    );

    final geldigTotBon = Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Text(
        'Geldig tot ' + maakDatum(),
        style: TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );

    final valideerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            verifieerCadeaubon();
          },
          color: Colors.lightBlueAccent,
          child: Text('Verifieer de cadeaubon',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final scanButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
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
          child: Text('Ga terug naar scannen',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Cadeaubon verificatie",
            style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            afbeelding,
            SizedBox(height: 15.0),
            naamBon,
            SizedBox(height: 10.0),
            geldigTotBon,
            SizedBox(height: 10.0),
            bedragBon,
            SizedBox(height: 20.0),
            valideerButton,
            SizedBox(height: 5.0),
            scanButton,
          ],
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(
        "Er is een fout opgetreden bij het valideren van de cadeaubon.");
  }

  @override
  void onLoginSucces(Response response) {
    _showSnackBar("De cadeaubon is succesvol gevalideerd!");
  }
}
