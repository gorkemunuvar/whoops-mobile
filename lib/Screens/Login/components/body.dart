import 'package:flutter/material.dart';
import 'package:notes_on_map/Screens/Login/components/background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Whoops!',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Kullanıcı Adı",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red)),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Şifre",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Here is the checkbox'),
              Text('Forgot Password'),
            ],
          )
        ],
      ),
    );
  }
}

/* SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/icons/login.png",
              height: size.height * 0.35,
              fit: BoxFit.fill,
            ),

            /* SvgPicture.asset(
              "assets/icons/login.png",
              height: size.height * 0.35,
            ), */
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MapScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
     */
