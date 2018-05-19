import '../../data/rest_data.dart';
import '../../models/cadeaubon.dart';

abstract class ScanPageContract {
  void onScanSucces(Cadeaubon cadeaubon);
  void onScanError(String error);
}

class ScanPagePresenter {
  ScanPageContract _view;
  RestData api = new RestData();
  ScanPagePresenter(this._view);

  doScan(String qrcode) {
    api
        .haalCadeaubonOp(qrcode)
        .then((cadeaubon) => _view.onScanSucces(cadeaubon))
        .catchError((onError) => _view.onScanError(onError.toString()));
  }
}
