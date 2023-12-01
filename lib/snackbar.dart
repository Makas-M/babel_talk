import 'package:flutter/material.dart';

void showSnackbar(BuildContext context) {
  // Cria uma instância do SnackBar
  final snackBar = SnackBar(
    content: const Text('Sem conexção'),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Fechar',
      onPressed: () {
        // Adiciona ação ao botão de fechar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  // Exibe a Snackbar na parte inferior da tela
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
