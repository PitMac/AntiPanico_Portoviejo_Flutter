import 'package:flutter/cupertino.dart';

class ValidationProvider with ChangeNotifier {
  bool isLoading = false;
  String message = '';

  bool isSecureLoginForm(
    TextEditingController email,
    TextEditingController password,
  ) {
    message = '';
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.text)) {
      message = "Por favor ingrese un correo valido";
      return false;
    } else if (password.text.length < 8) {
      message = "Por favor ingrese una contraseña valida";
      return false;
    } else {
      return true;
    }
  }

  bool isSecureRegisterForm(
    TextEditingController names,
    TextEditingController lastnames,
    TextEditingController cedula,
    TextEditingController email,
    TextEditingController password,
  ) {
    message = '';
    if (names.text.isEmpty) {
      message = 'Ingrese nombres validos';
      return false;
    } else if (lastnames.text.isEmpty) {
      message = 'Ingrese apellidos validos';
      return false;
    } else if (cedula.text.length < 10) {
      message = 'Ingrese una cedula valida';
      return false;
    } else if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email.text)) {
      message = "Por favor ingrese un correo valido";
      return false;
    } else if (password.text.length < 8) {
      message = "Por favor ingrese una contraseña valida";
      return false;
    } else {
      return true;
    }
  }
}
