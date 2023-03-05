import 'package:antipanico_portoviejo_flutter/providers/validation_provider.dart';
import 'package:flutter/material.dart';

SnackBar snackBarWidget(ValidationProvider validationProvider, Color color) {
  return SnackBar(
    content: Row(
      children: [
        Text(
          validationProvider.message,
          style: const TextStyle(color: Colors.white),
        ),
        const Expanded(child: SizedBox()),
        if (validationProvider.isLoading)
          const CircularProgressIndicator(color: Colors.white),
      ],
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  );
}

SnackBar snackBarWidget2(ValidationProvider validationProvider, Color color) {
  return SnackBar(
    content: Row(
      children: [
        const Text(
          "Usuario creado",
          style: TextStyle(color: Colors.white),
        ),
        const Expanded(child: SizedBox()),
        if (validationProvider.isLoading)
          const CircularProgressIndicator(color: Colors.white),
      ],
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  );
}
