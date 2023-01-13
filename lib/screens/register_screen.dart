import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final seePassword = useState(true);
    final size = MediaQuery.of(context).size;

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
              child: SingleChildScrollView(
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
                      textField('Nombre: ', false, Icons.abc_rounded),
                      const SizedBox(height: 15),
                      textField('Apellidos: ', false, Icons.abc_rounded),
                      const SizedBox(height: 15),
                      textField(
                          'Cedula: ', false, Icons.account_circle_rounded),
                      const SizedBox(height: 15),
                      textField(
                          'Correo: ', false, Icons.alternate_email_rounded),
                      const SizedBox(height: 15),
                      TextField(
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
                                  (states) => Colors.blueAccent)),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
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

  Widget textField(String title, bool isPassword, IconData icon) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        // icon: const Icon(Icons.abc),

        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: title,
      ),
    );
  }
}

// class RegisterScreen extends HookWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final seePassword = useState(true);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Registrar',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Nombre:',
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Apellidos:',
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Cedula:',
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Correo:',
//                 ),
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 obscureText: seePassword.value,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   labelText: 'Contraseña:',
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       seePassword.value = !seePassword.value;
//                     },
//                     icon: Icon(
//                       seePassword.value
//                           ? Icons.remove_red_eye_outlined
//                           : Icons.remove_red_eye,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: Colors.blueAccent,
//                     // gradient: const LinearGradient(colors: [
//                     //   skyblueColor,
//                     //   blueColor,
//                     // ]),
//                     borderRadius: BorderRadius.circular(20)),
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateColor.resolveWith(
//                           (states) => Colors.blueAccent)),
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/home');
//                   },
//                   child: const Text(
//                     'Registrar',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
