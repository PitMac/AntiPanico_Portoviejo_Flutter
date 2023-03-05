import 'package:antipanico_portoviejo_flutter/providers/map_provider.dart';
import 'package:antipanico_portoviejo_flutter/providers/validation_provider.dart';
import 'package:antipanico_portoviejo_flutter/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seePassword = useState(true);
    final size = MediaQuery.of(context).size;
    final namesController = useTextEditingController(text: '');
    final lastnamesController = useTextEditingController(text: '');
    final cedulaController = useTextEditingController(text: '');
    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');
    final validationProvider = Provider.of<ValidationProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
        ),
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
              height: size.height * 0.3,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.crisis_alert_rounded,
                    color: Colors.white,
                    size: size.width * 0.35,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                height: size.height * 0.7,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Registro de usuario',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      textField('Nombres: ', false, Icons.abc_rounded,
                          namesController, false),
                      const SizedBox(height: 15),
                      textField('Apellidos: ', false, Icons.abc_rounded,
                          lastnamesController, false),
                      const SizedBox(height: 15),
                      textField('Cedula: ', false, Icons.account_circle_rounded,
                          cedulaController, true),
                      const SizedBox(height: 15),
                      textField(
                          'Correo: ',
                          false,
                          Icons.alternate_email_rounded,
                          emailController,
                          false),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: seePassword.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Contraseña:',
                          suffixIcon: IconButton(
                            onPressed: () {
                              seePassword.value = !seePassword.value;
                            },
                            icon: Icon(
                              seePassword.value
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          onPressed: () async {
                            final state =
                                validationProvider.isSecureRegisterForm(
                              namesController,
                              lastnamesController,
                              cedulaController,
                              emailController,
                              passwordController,
                            );
                            if (state) {
                              // Navigator.pushReplacementNamed(context, '/home');
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBarWidget(
                                    validationProvider, Colors.blueAccent),
                              );
                              await validationProvider.signIn(
                                namesController,
                                lastnamesController,
                                cedulaController,
                                emailController,
                                passwordController,
                              );
                              mapProvider.getPeople();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBarWidget2(
                                    validationProvider, Colors.redAccent),
                              );
                            }
                          },
                          child: const Text(
                            'Registrar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backButton(context),
          ],
        ),
      ),
    );
  }

  Container backButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget textField(String title, bool isPassword, IconData icon,
      TextEditingController controller, bool iscedula) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: iscedula ? TextInputType.number : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: title,
      ),
    );
  }
}
