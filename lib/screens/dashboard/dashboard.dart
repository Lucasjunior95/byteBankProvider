import 'dart:ui';
import 'package:bytebank_Provider/models/cliente.dart';
import 'package:bytebank_Provider/screens/autenticacao/login.dart';
import 'package:bytebank_Provider/screens/dashboard/saldo.dart';
import 'package:bytebank_Provider/screens/deposito/formulario.dart';
import 'package:bytebank_Provider/screens/transferencia/formulario.dart';
import 'package:bytebank_Provider/screens/transferencia/ultimas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:  Text('ByteBank',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        )
        ),
      body: Column(
        children: [
          Consumer<Cliente>(builder: (context, cliente, child) {
            if (cliente.nome != null) {
              return Text(
                'Olá ${cliente.nome.split(' ')[0]}, seu saldo de hoje é',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 3,
                ),
              );
            }
            return Text(
              'Olá, seu saldo de hoje é: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: SaldoCard(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Receber depósito'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FormularioDeposito();
                      },
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Nova Transferência'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FormularioTransferencia();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          UltimasTransferencias(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (route) => false);
            },
            // color: Colors.green,
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }
}
