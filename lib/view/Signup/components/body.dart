import 'package:flutter/material.dart';
import 'package:whoops/constants.dart';
import 'package:whoops/controller/networking.dart';
import 'package:whoops/view/utils/button_component.dart';
import 'package:whoops/view/utils/text_field_component.dart';
import 'package:whoops/view/SignUp/components/background.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _emailInput = '';
  String _usernameInput = '';
  String _passwordInput = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height / 3,
              ),
              Text(
                'Kayıt Ol',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: kPrimaryDarkColor,
                ),
              ),
              SizedBox(height: 20),
              TextFieldComponent(
                hintText: 'Email',
                onChanged: (value) {
                  _emailInput = value;
                },
              ),
              TextFieldComponent(
                hintText: 'Kullanıcı Adı',
                onChanged: (value) {
                  _usernameInput = value;
                },
              ),
              TextFieldComponent(
                hintText: 'Şifre',
                onChanged: (value) {
                  _passwordInput = value;
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              ButtonComponent(
                text: 'Kayıt Ol',
                textColor: kPrimaryWhiteColor,
                backgroundColor: kPrimaryDarkColor,
                onPressed: () {
                  _handleSignup(
                    context,
                    _emailInput,
                    _usernameInput,
                    _passwordInput,
                  );
                },
              ),
              SizedBox(height: 10),
              ButtonComponent(
                text: 'Giriş',
                textColor: kPrimaryDarkColor,
                backgroundColor: kPrimaryWhiteColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
              SizedBox(height: 75),
              Center(
                child: Text(
                  'ile kayıt ol',
                  style:
                      TextStyle(color: kPrimaryDarkColor, fontFamily: 'Roboto'),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage("assets/icons/google.png"),
                    size: 50.0,
                  ),
                  SizedBox(width: 7),
                  ImageIcon(
                    AssetImage("assets/icons/facebook.png"),
                    size: 42.0,
                  ),
                  SizedBox(width: 7),
                  ImageIcon(
                    AssetImage("assets/icons/twitter.png"),
                    size: 52.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignup(
    BuildContext context,
    String email,
    String username,
    String password,
  ) async {
    Map<String, String> body = {
      'email': email,
      'username': username,
      'password': password,
    };

    //Parametreler ile  POST isteği yap
    http.Response response =
        await Networking.post('$kServerUrl/user/signup', body);

    //Eğer başarılı ise Login Page' yönlendir
    if (response.statusCode == 201) {
      print('Kayıt olma işlemi başarılı.');
      // TODO: Burada sign in yerine map screen'e yönlendirilebilir.
      Navigator.pushNamed(context, '/signIn');
    }
    //Hatalı sonuç döner ise uyarı ver.
    else
      print('${response.statusCode}. Bir hata ile karşılaştınız.');
  }
}
