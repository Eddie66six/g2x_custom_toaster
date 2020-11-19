import 'package:flutter/material.dart';
import 'package:g2x_custom_toaster/g2x_custom_toaster.dart';

void main() {
  runApp(MyApp());
}

final _navigationKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var index = 0;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var mensage = [
    '''O incentivo ao avanço tecnológico, assim como a determinação clara de objetivos estimula a padronização das regras de conduta normativas.''',
    '''Caros amigos, a infinita diversidade da realidade única nos obriga à análise da cartografia dessa rede urbana de ligações subterrâneas. Por outro lado, o advento do Utilitarismo radical cumpre um papel essencial na formulação da fundamentação metafísica das representações.'''
    ];
    var title = [
      'O incentivo ao avanço tecnológico da seila o que sdfasdf sdfas ',
      'Caros amigos'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Toaster"),
        actions: [
          Icon(Icons.ac_unit),
          Icon(Icons.ac_unit_rounded),
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey,
      body: Center(child: RaisedButton(child: Text("Show"), onPressed: (){
        index = index + 1;
        G2xCustomToaster.showOnTop(
          icon: index%2 == 0 ? Icons.notifications : Icons.chat,
          title: title[index%2 == 0 ? 0 : 1],
          mensage: mensage[index%2 == 0 ? 0 : 1],
          navigationKey: _navigationKey,
          onTap: (){
            print('tap');
          },
          onFinish: (){
            print('finish');
            index = index - 1;
          },
        );
      },)),
    );
  }
}