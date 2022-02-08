import 'package:bytebank_Provider/components/mensagem.dart';
import 'package:bytebank_Provider/screens/autenticacao/registrar.dart';
import 'package:bytebank_Provider/screens/dashboard/dashboard.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatelessWidget {
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 65),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/bytebank_logo.png',
                  width: 200,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 455,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _construirFormulario(context)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Widget _construirFormulario(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Faça o seu login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'CPF',
            ),
            maxLength: 14,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            validator: (value) {
              if (value!.length == 0) {
                return 'Informe o CPF';
              }
              if (value.length < 14) {
                return 'CPF inválido';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            controller: _cpfController,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
            ),
            maxLength: 16,
            validator: (value) {
              if (value!.length == 0) {
                return 'Informe uma senha';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            controller: _senhaController,
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              width: double.infinity,
              child: OutlineButton(
                textColor: Theme.of(context).accentColor,
                highlightColor: Color.fromRGBO(71, 161, 56, 0.2),
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_cpfController.text == '123.456.789-10' &&
                        _senhaController.text == 'abc123') {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ),
                          (route) => false);
                    } else {
                      exibirAlerta(
                        context: context,
                        titulo: 'ATENÇÃO',
                        content: 'CPF ou senha incorretos!',
                      );
                    }
                  }
                },
                child: Text('Continuar'),
              )),
          SizedBox(
            height: 15,
          ),
          Text(
            'Esqueci minha senha >',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          OutlineButton(
            textColor: Theme.of(context).accentColor,
            highlightColor: Color.fromRGBO(71, 161, 56, 0.2),
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
            child: Text(
              'Criar uma conta >',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registrar()),
              );
            },
          ),
        ],
      ),
    );
  }
}
