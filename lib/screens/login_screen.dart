import 'package:antipanico_portoviejo_flutter/providers/validation_provider.dart';
import 'package:antipanico_portoviejo_flutter/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
        ),
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/background.jpg'),
                  opacity: 0.35,
                  fit: BoxFit.cover,
                ),
              ),
              height: size.height * 0.5,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.crisis_alert_rounded,
                    color: Colors.white,
                    size: size.width * 0.4,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Anti-pánico\nPortoviejo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            FormWidget(size: size),
          ],
        ),
      ),
    );
  }
}

class FormWidget extends HookWidget {
  const FormWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final validationProvider = Provider.of<ValidationProvider>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          height: size.height * 0.5,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Inicio de sesión',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              textField('Correo: ', false, 'test@test.com', Icons.person,
                  emailController),
              const SizedBox(height: 20),
              textField('Contraseña: ', true, '*********', Icons.lock,
                  passwordController),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueAccent),
                  ),
                  onPressed: () {
                    final state = validationProvider.isSecureLoginForm(
                        emailController, passwordController);
                    if (state) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        snackBarWidget(validationProvider, Colors.redAccent),
                      );
                    }
                  },
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No tienes cuenta todavia?  '),
                  InkWell(
                    child: Text(
                      'Registrar',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String title, bool isPassword, String hintText,
      IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
