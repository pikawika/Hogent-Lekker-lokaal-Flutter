import '../../data/rest_data.dart';
import '../../models/handelaar.dart';

abstract class LoginPageContract {
  void onLoginSucces(Handelaar handelaar);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  RestData api = new RestData();
  LoginPagePresenter(this._view);

  doLogin(String username, String password) {
    api
        .meldHandelaarAan(username, password)
        .then((handelaar) => _view.onLoginSucces(handelaar))
        .catchError((onError) => _view.onLoginError(onError.toString()));
  }
}
