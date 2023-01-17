import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidationProvider with ChangeNotifier {
  bool isLoading = false;
  String message = '';
  final mapProvider = MapProvider();
  FirebaseFirestore db = FirebaseFirestore.instance;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool logIn(
    TextEditingController email,
    TextEditingController password,
    List<dynamic> people,
  ) {
    var emailExist = false;
    var passExist = false;
    for (var i = 0; i < people.length; i++) {
      emailExist = false;
      passExist = false;
      if (people[i]['correo'] == email.text) {
        emailExist = true;
      }
      if (emailExist && people[i]['clave'] == password.text) {
        passExist = true;
      }
      if (emailExist && passExist) {
        _prefs.then((value) => value.setString('user', people[i]['correo']));
        return true;
      }
      if (emailExist) {
        message = 'Contraseña incorrecta';
        return false;
      }
    }
    message = 'No existe cuenta con ese correo';
    return false;
  }

  bool isSecureLoginForm(
    TextEditingController email,
    TextEditingController password,
    List<dynamic> people,
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
      isLoading = true;
      notifyListeners();
      final logIn = this.logIn(email, password, people);
      if (logIn) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
  }

  Future<void> signIn(
    TextEditingController names,
    TextEditingController lastnames,
    TextEditingController cedula,
    TextEditingController email,
    TextEditingController password,
  ) async {
    final user = await db.collection("usuario").add({
      "nombres": names.text,
      "apellidos": lastnames.text,
      "cedula": int.parse(cedula.text),
      "correo": email.text,
      "clave": password.text
    });
    print(user);
    message = 'Usuario creado correctamente';
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
    } else if (cedula.text.length != 10 || !isValidCI(int.parse(cedula.text))) {
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

  bool isValidCI(int ci) {
    var isNumeric = true;
    // ignore: prefer_typing_uninitialized_variables
    var total = 0, individual;
    for (var position = 0; position < 10; position++) {
      // Obtiene cada posición del número de cédula
      // Se convierte a string en caso de que 'ci' sea un valor numérico
      individual = ci.toString().substring(position, position + 1);

      if (individual == null) {
        isNumeric = false;
        break;
      } else {
        // Si la posición es menor a 9
        if (position < 9) {
          // Si la posición es par, osea 0, 2, 4, 6, 8.
          if (position % 2 == 0) {
            // Si el número individual de la cédula es mayor a 5
            if (int.parse(individual) * 2 > 9) {
              // Se duplica el valor, se obtiene la parte decimal y se aumenta uno
              // y se lo suma al total
              total += 1 + ((int.parse(individual) * 2) % 10);
            } else {
              // Si el número individual de la cédula es menor que 5 solo se lo duplica
              // y se lo suma al total
              total += int.parse(individual) * 2;
            }
            // Si la posición es impar (1, 3, 5, 7)
          } else {
            // Se suma el número individual de la cédula al total
            total += int.parse(individual);
          }
        }
      }
    }
    if ((total % 10) != 0) {
      total = (total - (total % 10) + 10) - total;
    } else {
      total = 0;
    }

    if (isNumeric) {
      // El total debe ser igual al último número de la cédula
      // La cédula debe contener al menos 10 dígitos
      if (ci.toString().length != 10) {
        return false;
      }

      // El número de cédula no debe ser cero
      if (int.parse(ci.toString()) == 0) {
        return false;
      }

      // El total debe ser igual al último número de la cédula
      if (total != int.parse(individual)) {
        return false;
      }

      return true;
    }

    // Si no es un número
    return false;
  }
}
