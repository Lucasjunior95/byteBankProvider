import 'dart:io';

import 'package:bytebank_Provider/models/cliente.dart';
import 'package:bytebank_Provider/screens/dashboard/dashboard.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class Registrar extends StatelessWidget {
  //step 1
  final _formUserData = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();

  //step 2
  final _formUserAddress = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  //step 3
  final _formUserAuth = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente'),
      ),
      body: Consumer<Cliente>(builder: (context, cliente, child) {
        return Stepper(
          currentStep: cliente.stepAtual,
          onStepContinue: () {
            final functions = [
              _salvarStep1,
              _salvarStep2,
              _salvarStep3,
            ];
            return functions[cliente.stepAtual](context);
          },
          onStepCancel: () {
            cliente.stepAtual =
                cliente.stepAtual > 0 ? cliente.stepAtual - 1 : 0;
          },
          steps: _construirSteps(context, cliente),
          controlsBuilder: (context, ControlsDetails controls) {
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: Text('Salvar'),
                  ),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  ElevatedButton(
                    onPressed: controls.onStepCancel,
                    child: Text('Voltar'),
                  ),
                ],
              ),
            );
          },
        );
      }),

      /*body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    controller: _nomeController,
                    maxLength: 255,
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value!.length == 0){
                        return 'Didite o nome';
                      }
                      if (value.length < 2){
                        return 'Nome inválido!';
                      }
                      if (!value.contains(' ')){
                        return 'Informe ao menos o sobrenome';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                    ),
                    controller: _emailController,
                    maxLength: 255,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.length == 0){
                        return 'Digite o e-mail';
                      }
                      if(value.length < 2)
                        return 'E-mail inválido';
                      if(!value.contains('@') || !value.contains('.'))
                        return 'Formato de e-mail inválido';
                    }),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CPF',
                    ),
                    controller: _cpfController,
                    maxLength: 14,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    validator: (value) {
                      if(value!.length == 0)
                        return 'Informe o CPF ';

                        if(value.length != 14)
                          return 'CPF inválido';
                        return null;

                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Celular',
                    ),
                    controller: _celularController,
                    maxLength: 15,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    validator: (value) {
                      if(value!.isEmpty)
                        return 'Informe o número de telefone';

                        if (value.length < 14)
                          return 'Número inválido';
                        return null;
                    },
                  ),

                  DateTimePicker(
                    controller: _nascimentoController,
                    type: DateTimePickerType.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Nascimento',
                    dateMask: 'dd/MM/yyyy',
                    validator: (value){
                      if(value!.isEmpty)
                        return 'Insira uma data';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CEP',
                    ),
                    controller: _cepController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(),
                    ],
                    validator: (value) {
                      if(value!.length == 0)
                        return 'Didite o CEP';
                      if(value.length < 10)
                          return 'CEP inválido';
                        return null;
                      }
                  ),

                  DropdownButtonFormField(
                   // isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Estado',
                    ),
                    items: Estados.listaEstadosSigla.map((String estado) {
                      return DropdownMenuItem(child: Text(estado), value: estado,);
                    }).toList(),
                    onChanged: (String? novoEstadoSelecionado){
                      _estadoController.text = novoEstadoSelecionado!;
                    },
                    validator: (value){
                      if(value == null)
                        return 'Selecione um estado';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cidade',
                    ),
                    controller: _cidadeController,
                    maxLength: 255,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if(value!.length < 3){
                        return 'Informe sua cidade';
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Bairro',
                    ),
                    controller: _bairroController,
                    maxLength: 255,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if(value!.length == 0){
                        return 'Informe o bairro';

                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Logradouro',
                    ),
                    controller: _logradouroController,
                    maxLength: 255,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if(value!.length == 0){
                        return 'Informe o logradouro';

                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Número',
                    ),
                    controller: _numeroController,
                    validator: (value) {
                      if(value!.length == 0){
                        return 'Informe o número';

                        return null;
                      }
                    },
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
                      'Finalizar Cadastro >',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _salvar(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(),
                            ),
                                (route) => false);
                        }
                      }
                  ),
                ],
              ),
          ),
        ),
      ),*/
    );
  }

  /* void _salvar(context){
    Provider.of<Cliente>(context, listen: false).nome = _nomeController.text;
  }*/
  void _salvarStep1(context) {
    // if (_formUserData.currentState!.validate()) {
    //   Cliente cliente = Provider.of<Cliente>(context, listen: false);
    //   cliente.nome = _nomeController.text;
    _proximoStep(context);
    // }
  }

  void _salvarStep2(context) {
    // if (_formUserAddress.currentState!.validate()) {
    _proximoStep(context);
    // }
  }

  void _salvarStep3(context) {
    if (_formUserAuth.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    }
  }

  List<Step> _construirSteps(context, cliente) {
    List<Step> step = [
      Step(
        title: Text('Dados pessoais'),
        isActive: cliente.stepAtual >= 0,
        content: Form(
          key: _formUserData,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                controller: _nomeController,
                maxLength: 255,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Didite o nome';
                  }
                  if (value.length < 2) {
                    return 'Nome inválido!';
                  }
                  if (!value.contains(' ')) {
                    return 'Informe ao menos o sobrenome';
                  }
                  return null;
                },
              ),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                  controller: _emailController,
                  maxLength: 255,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Digite seu e-mail';
                    }
                    if (value.length < 2) return 'E-mail inválido';
                    if (!value.contains('@') || !value.contains('.'))
                      return 'Formato de e-mail inválido';
                  }),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CPF',
                ),
                controller: _cpfController,
                maxLength: 14,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                validator: (value) =>
                    Validator.cpf(value) ? 'CPF inválido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Celular',
                ),
                controller: _celularController,
                maxLength: 15,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                validator: (value) {
                  if (value!.isEmpty) return 'Informe o número de telefone';

                  if (value.length < 14) return 'Número inválido';
                  return null;
                },
              ),
              DateTimePicker(
                controller: _nascimentoController,
                type: DateTimePickerType.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Nascimento',
                dateMask: 'dd/MM/yyyy',
                validator: (value) {
                  if (value!.isEmpty) return 'Insira uma data';

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text('Endereço'),
        isActive: cliente.stepAtual >= 1,
        content: Form(
          key: _formUserAddress,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CEP',
                  ),
                  controller: _cepController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  validator: (value) {
                    if (value!.length == 0) return 'Didite o CEP';
                    if (value.length < 10) return 'CEP inválido';
                    return null;
                  }),
              DropdownButtonFormField(
                // isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Estado',
                ),
                items: Estados.listaEstadosSigla.map((String estado) {
                  return DropdownMenuItem(
                    child: Text(estado),
                    value: estado,
                  );
                }).toList(),
                onChanged: (String? novoEstadoSelecionado) {
                  _estadoController.text = novoEstadoSelecionado!;
                },
                validator: (value) {
                  if (value == null) return 'Selecione um estado';
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cidade',
                ),
                controller: _cidadeController,
                maxLength: 255,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.length < 3) {
                    return 'Informe sua cidade';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bairro',
                ),
                controller: _bairroController,
                maxLength: 255,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Informe o bairro';

                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                ),
                controller: _logradouroController,
                maxLength: 255,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Informe o logradouro';

                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número',
                ),
                controller: _numeroController,
                validator: (value) {
                  if (value!.length == 0) {
                    return 'Informe o número';

                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text('Autenticação'),
        isActive: cliente.stepAtual >= 1,
        content: Form(
          key: _formUserAuth,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                controller: _senhaController,
                maxLength: 255,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Senha muito curta, minímo 8 caracteres';
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                ),
                controller: _confirmarSenhaController,
                maxLength: 255,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != _senhaController.text) {
                    return 'As senhas não correspondem';
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Para prosseguir com o seu cadastro é necessário que tenhamos uma foto do seu RG.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () => _capturarRG(cliente),
                child: Text('Tirar foto do RG'),
              ),
              _jaEnviouRG(context) ? _imagemRG(context) : _pedidoRG(context),
            ],
          ),
        ),
      ),
    ];
    return step;
  }

  _proximoStep(context){
    Cliente cliente = Provider.of<Cliente>(context, listen: false);
    irPara(cliente.stepAtual + 1, cliente);
  }

  irPara(int step, cliente) {
    cliente.stepAtual = step;
  }

  void _capturarRG(cliente) async{
    final pickerImage = await _picker.getImage(source: ImageSource.camera);
    cliente.imagemRG = File(pickerImage!.path);
  }

  bool _jaEnviouRG(context){
    if (Provider.of<Cliente>(context).imagemRG != null) return true;
    return false;
  }

  Image _imagemRG(context){
    return Image.file(Provider.of<Cliente>(context).imagemRG as File);
  }

  Text _pedidoRG(context){
    return const Text(
      'Foto do RG pendente.',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}
