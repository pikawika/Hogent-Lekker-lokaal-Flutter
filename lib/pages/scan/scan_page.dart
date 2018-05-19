import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import '../../models/cadeaubon.dart';
import 'scan_presenter.dart';

class ScanPage extends StatefulWidget {
  static String tag = 'scan-page';
  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> implements ScanPageContract {
  String barcode = "";

  ScanPagePresenter _presenter;

  _ScanPageState() {
    _presenter = new ScanPagePresenter(this);
  }

  void _scan(String qrcode) {
    _presenter.doScan(qrcode);
  }

  @override
  initState() {
    super.initState();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('QR-code scanner',
                style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: Colors.lightBlue,
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new MaterialButton(
                      onPressed: scan, child: new Text("Scan")),
                  padding: const EdgeInsets.all(8.0),
                ),
                new Text(barcode),
              ],
            ),
          )),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      _scan(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode =
              'U moet deze applicatie toegang geven tot de camera van uw toestel.';
        });
      } else {
        setState(() => this.barcode = 'Onbekende error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'U heeft het scannen gestopt en er is geen resultaat uit voort gekomen.');
    } catch (e) {
      setState(() => this.barcode = 'Onbekende error: $e');
    }
  }

  @override
  void onScanError(String error) {
    setState(() => this.barcode =
        'Er is een fout opgetreden bij het ophalen van de gegevens. Gelieve het opnieuw te proberen.');
  }

  @override
  void onScanSucces(Cadeaubon cadeaubon) {
    setState(() => this.barcode = cadeaubon.aanmaakDatum.toString());
  }
}
