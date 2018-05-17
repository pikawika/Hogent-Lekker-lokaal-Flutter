import '../../data/rest_data.dart';
import '../../models/handelaar.dart';

abstract class LoginPageContract {
  void OnLoginSucces(Handelaar handelaar);
  void OnLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  RestData api = new RestData();
  LoginPagePresenter(this._view);

  doLogin(String username, String password) {
    api
        .meldHandelaarAan(username, password)
        .then((handelaar) => _view.OnLoginSucces(handelaar))
        .catchError((onError) => _view.OnLoginError(onError.toString()));
  }
}
