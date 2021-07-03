import 'package:flutter/material.dart';
import 'package:whoops/view/Map/components/body.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("deneme"),
              )
            ],
          ),
        ),
        body: Body(),
      ),
    );
  }
}
