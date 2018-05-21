import 'package:http/http.dart';

import '../../data/rest_data.dart';
import '../../models/cadeaubon.dart';

abstract class BonPageContract {
  void onLoginSucces(Response response);
  void onLoginError(String error);
}

class BonPagePresenter {
  BonPageContract _view;
  RestData api = new RestData();
  BonPagePresenter(this._view);

  doValidatie(Cadeaubon cadeaubon) {
    api
        .valideerCadeaubon(cadeaubon)
        .then((response) => _view.onLoginSucces(response))
        .catchError((onError) => _view.onLoginError(onError.toString()));
  }
}
