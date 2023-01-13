import 'package:antipanico_portoviejo_flutter/screens/home_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/login_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/people_screen.dart';
import 'package:antipanico_portoviejo_flutter/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';

final routes = {
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const RegisterScreen(),
  '/home': (BuildContext context) => const HomeScreen(),
  '/people': (BuildContext context) => const PeopleScreen(),
};
