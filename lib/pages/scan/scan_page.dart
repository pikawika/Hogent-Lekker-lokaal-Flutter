import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import '../../data/database_helper.dart';
import '../../models/cadeaubon.dart';
import '../bon_page/bon_page.dart';
import 'scan_presenter.dart';

class ScanPage extends StatefulWidget {
  static String tag = 'scan-page';
  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> implements ScanPageContract {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  var qrcodeController;
  final db = new DatabaseHelper();

  ScanPagePresenter _presenter;

  _ScanPageState() {
    _presenter = new ScanPagePresenter(this);
    qrcodeController = new TextEditingController();
  }

  void _scan(String qrcode) {
    _presenter.doScan(qrcode);
  }

  void _manueleScan() {
    if (qrcodeController.text != null && qrcodeController.text != "") {
      _scan(qrcodeController.text);
    } else {
      _showSnackBar("Gelieve een QR-code in te voeren.");
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      duration: Duration(seconds: 4),
    ));
  }

  @override
  initState() {
    scan();
    super.initState();
  }

  @override
  void dispose() {
    qrcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: scan,
          color: Colors.lightBlueAccent,
          child:
              Text('Gebruik de scanner', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final ofText = Text(
      'of voer de QR-code manueel in',
      textAlign: TextAlign.center,
    );

    final eigenQRCode = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: qrcodeController,
      decoration: InputDecoration(
          hintText: 'QR-code',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final manueleScan = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: _manueleScan,
          color: Colors.lightBlueAccent,
          child: Text('Gebruik manuele QR-code',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final hulpLabel = FlatButton(
      child: Text('Hulp nodig?', style: TextStyle(color: Colors.black54)),
      onPressed: () {
        _showSnackBar(
            "Klik op de knop 'Gebruik de scanner' om een QR-code in te scannen, of voer manueel een QR-code in en druk op de knop 'Gebruik manuele QR-code'.");
      },
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("QR-code Scanner", style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            scanButton,
            SizedBox(height: 25.0),
            ofText,
            SizedBox(height: 30.0),
            eigenQRCode,
            manueleScan,
            SizedBox(height: 30.0),
            hulpLabel,
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      _scan(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showSnackBar(
            'U moet deze applicatie toegang geven tot de camera van uw toestel.');
      } else {
        _showSnackBar('Onbekende error: $e');
      }
    } on FormatException {
      _showSnackBar(
          'U heeft het scannen gestopt en er is geen resultaat uit voort gekomen.');
    } catch (e) {
      _showSnackBar('Onbekende error: $e');
    }
  }

  @override
  void onScanError(String error) {
    _showSnackBar(
        'Er is een fout opgetreden bij het ophalen van de gegevens. Gelieve het opnieuw te proberen.');
  }

  @override
  void onScanSucces(Cadeaubon cadeaubon) async {
    Cadeaubon huidigeCadeaubon = await db.getCadeaubon();
    if (huidigeCadeaubon == null)
      await db.saveCadeaubon(cadeaubon);
    else
      await db.updateCadeaubon(cadeaubon);
    Navigator.of(context).pushNamed(BonPage.tag);
  }
}
