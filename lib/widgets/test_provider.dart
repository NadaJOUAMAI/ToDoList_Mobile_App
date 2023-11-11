import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserTheme(),
      child: MyApp(),
    ),
  );
}

class UserTheme extends ChangeNotifier {
  int count;
  Color backgroundColor;

  UserTheme({this.count = 5, this.backgroundColor = Colors.black});

  void incrementCount() {
    count++;
    notifyListeners();
  }

  void changeBackgroundColor(Color bgColor) {
    backgroundColor = bgColor;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userTheme = Provider.of<UserTheme>(context);
    // Accès au modèle de données

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: userTheme.backgroundColor,
          child: Center(
            child: Column(
              children: [
                Text(
                  userTheme.count.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    userTheme.incrementCount(); // Appel de la méthode pour incrémenter le compteur
                  },
                  child: Text('Increment'),
                ),
                ElevatedButton(
                  onPressed: () {
                    userTheme.changeBackgroundColor(Colors.purple); // Appel de la méthode pour changer la couleur de l'arrière-plan
                  },
                  child: Text('Change Color'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}