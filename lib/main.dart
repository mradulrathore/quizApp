import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Questions.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
          accentColorBrightness: Brightness.dark),
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: Icons.query_builder,
          nextScreen: Questions(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.blue,
    )
    );}
}


/*
class display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: 
                ListView.builder(
                  itemCount: 10,                 
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text('Question-1'),
                      leading: CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        child: Text('A'),
                      ),
                    );
                  }
                ),
              ),
            );  
  }
}





*/
