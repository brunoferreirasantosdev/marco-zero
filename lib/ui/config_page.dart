import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configurar o Firebase', style: TextStyle(fontFamily: 'Georgia', fontSize: 28)),
                  SizedBox(height: 12),
                  Text(
                    'O login do consultor usa Firebase Auth. Enquanto o projeto não estiver ligado, o app não abre um acesso provisório.',
                  ),
                  SizedBox(height: 16),
                  Text('1. Crie um projeto Firebase e ative Authentication com e-mail e senha.'),
                  Text('2. Crie um banco Cloud Firestore.'),
                  Text('3. Nesta pasta, com a CLI autenticada, rode:'),
                  SizedBox(height: 8),
                  SelectableText('flutterfire configure --platforms=windows'),
                  SizedBox(height: 8),
                  Text('4. Publique as regras com:'),
                  SizedBox(height: 8),
                  SelectableText('firebase deploy --only firestore:rules'),
                  SizedBox(height: 16),
                  Text(
                    'Para as próximas versões chegarem sozinhas, publique com tool/publicar.ps1 e informe o endereço do latest.json.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
