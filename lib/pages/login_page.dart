import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toolkit_app/models/user_model.dart';
import 'package:toolkit_app/pages/signup_page.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if(model.isLoading)
              return Center(child: CircularProgressIndicator(),);

            return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@"))
                          return "E-mail inválido!";
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Senha inválida!";
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            if(_emailController.text.isEmpty){
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Insira seu e-mail para recuperação!"),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                  )
                              );
                            }else{
                              model.recoverPass(_emailController.text);
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Confira seu e-mail!"),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    duration: Duration(seconds: 3),
                                  )
                              );
                            }
                          },
                          padding: EdgeInsets.zero,
                          child: Text(
                            "Esqueci minha senha",
                            textAlign: TextAlign.right,
                          )),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                      ),
                    )
                  ],
                )
            );
          },
        )
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao Entrar!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
