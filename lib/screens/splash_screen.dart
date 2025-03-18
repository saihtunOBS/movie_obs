import 'package:flutter/material.dart';
import 'package:movie_obs/screens/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: ElevatedButton(onPressed: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> HomePage()));
    }, child: Text("go")),),);
  }
}