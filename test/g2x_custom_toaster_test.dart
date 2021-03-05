import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:g2x_custom_toaster/g2x_custom_toaster.dart';

void main() {
  final _navigationKey = GlobalKey<NavigatorState>();
  _buildInitApp(Widget child) {
    return MaterialApp(
        navigatorKey: _navigationKey, home: Scaffold(body: child));
  }

  testWidgets("open/close and callbacks toaster", (WidgetTester t) async {
    var countCallbacks = 0;
    await t.pumpWidget(_buildInitApp(FlatButton(
      child: Text(""),
      onPressed: () {
        G2xCustomToaster.showOnTop(
            icon: Icon(Icons.chat),
            title: "G2xCustomToaster Title",
            mensage: "Content",
            navigationKey: _navigationKey,
            onTap: () {
              countCallbacks++;
            },
            onFinish: () {
              countCallbacks++;
            });
      },
    )));
    await t.tap(find.byType(FlatButton));
    //slide down animation
    await t.pumpAndSettle(const Duration(milliseconds: 200));
    expect(find.byType(Column), findsOneWidget);
    //tap
    await t.tap(find.byType(FlatButton));
    //slide up animation
    await t.pumpAndSettle(const Duration(milliseconds: 1000));
    expect(find.byType(Column), findsNothing);

    expect(countCallbacks, 2);
  });

  testWidgets("open and manual close and callbacks toaster",
      (WidgetTester t) async {
    var countCallbacks = 0;
    await t.pumpWidget(_buildInitApp(FlatButton(
      child: Text(""),
      onPressed: () {
        G2xCustomToaster.showOnTop(
            icon: Icon(Icons.chat),
            title: "G2xCustomToaster Title",
            mensage: "Content",
            navigationKey: _navigationKey,
            onFinish: () {
              countCallbacks++;
            });
      },
    )));
    await t.tap(find.byType(FlatButton));
    //slide down animation
    await t.pumpAndSettle(const Duration(milliseconds: 200));
    expect(find.byType(Column), findsOneWidget);
    //tap
    await t.dragFrom(Offset(20, 50), Offset(100, 0));
    //slide up animation
    await t.pumpAndSettle(const Duration(milliseconds: 1000));
    expect(find.byType(Column), findsNothing);

    expect(countCallbacks, 1);
  });
}
