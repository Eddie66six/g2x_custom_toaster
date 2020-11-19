library g2x_custom_toaster;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class G2xCustomToaster{
  /// Show toaste on top
  ///
  /// [navigationKey] navigation key inserted in the mainapp(MaterialApp)
  /// 
  /// [milliseconds to discard] is the animation duration.
  /// 
  /// [onFinish] is called when finish animation.
  static void showOnTop({
      @required IconData icon,
      @required String title,
      @required String mensage,
      @required GlobalKey<NavigatorState> navigationKey,
      int millisecondsToStart = 200,
      int millisecondsToDismissAnd = 1000,
      Function onFinish,
      Function onTap
    }){
      _navigationKey = navigationKey;
      _overlayEntryForRemove.add(
        _buildEntry(icon,title, mensage,
        millisecondsToStart,
        millisecondsToDismissAnd,
        onFinish, onTap, _overlayEntryForRemove.length));
      if(_overlayEntryForRemove.length == 1){
        _insertNext(navigationKey);
      }
  }

  static GlobalKey<NavigatorState> _navigationKey;

  static _insertNext(GlobalKey<NavigatorState> navigationKey){
    if(_overlayEntryForRemove.length > 0)
      navigationKey.currentState.overlay.insert(_overlayEntryForRemove[0]);
  }

  static _removeFirst(){
    _overlayEntryForRemove[0].remove();
    _overlayEntryForRemove.removeAt(0);
    _insertNext(_navigationKey);
  }
  
  static var _overlayEntryForRemove = List<OverlayEntry>();
  static OverlayEntry _buildEntry(
    IconData icon,
    String title,
    String mensage,
    int millisecondsToStart,
    int millisecondsToDismissAnd,
    Function onFinish,
    Function onTap,
    int index
  ){
    var _overlayEntry = OverlayEntry(builder: (BuildContext buildContext){
      return _G2xCustomToasterComponent(
        key: UniqueKey(),
        title: title,
        mensage: mensage,
        millisecondsToStart: millisecondsToStart,
        millisecondsToDismissAnd: millisecondsToDismissAnd,
        onFinish: (){
          if(onFinish != null){
            onFinish();
          }
         _removeFirst();
        },
        onTap: onTap,
        icon: icon
      );
    });
    return _overlayEntry;
  }
}

class _G2xCustomToasterComponent extends StatefulWidget {
  final String title;
  final String mensage;
  final int millisecondsToStart;
  final int millisecondsToDismissAnd;
  final Function onFinish;
  final Function onTap;
  final IconData icon;
  const _G2xCustomToasterComponent({
    Key key, this.title, this.mensage,
    this.millisecondsToStart,
    this.millisecondsToDismissAnd,
    this.onFinish, this.onTap,this.icon
  }) : super(key: key);
  @override
  __G2xCustomToasterComponentState createState() => __G2xCustomToasterComponentState();
}

class __G2xCustomToasterComponentState extends State<_G2xCustomToasterComponent> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  var _globalKeyCard = GlobalKey();
  var _cardSize = Size.zero;
  Timer _timeToDismiss;
  var _pressing = false;
  var _dismiss = false;
  var _currentY = 1000.0;
  var _currentX = 0.0;
  var sizeScreen = Size.zero;

  @override
  void initState(){
    Future.delayed(Duration.zero, (){
      _cardSize = _globalKeyCard.currentContext.size;
      _buildVerticalAniomation(-_cardSize.height, MediaQuery.of(context).padding.top + 5, Curves.linear, false, widget.millisecondsToStart);
    });
    super.initState();
  }

  _buildVerticalAniomation(double begin, double end, Curve curve, bool finish, int milliseconds, {bool vertical = true}){
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: milliseconds));
      var _curve = CurvedAnimation(parent: _animationController, curve: curve);
      _animation = Tween<double>(begin: begin, end: end).animate(_curve);

      _animationController.addListener(() {
        if(_animationController.status == AnimationStatus.completed){
          if(vertical){
            _currentY = end;
            if(!finish) _buildTimer();
          }
          else{
            _currentX = end;
          }
          if(finish || !vertical){
            if(widget.onFinish != null) widget.onFinish();
          }
        }
        else{
          if(vertical){
            _currentY = _animation.value;
          }
          else{
            _currentX = _animation.value;
          }
        }
        setState(() {});
      });
      _animationController.forward();
  }

  _buildTimer(){
    _timeToDismiss?.cancel();
    _timeToDismiss = Timer(Duration(milliseconds: widget.millisecondsToDismissAnd), (){
      _dismiss = true;
      if(!_pressing){
        _buildVerticalAniomation(MediaQuery.of(context).padding.top + 5, -(_cardSize.height + 20), Curves.elasticIn, true, widget.millisecondsToDismissAnd);
      }
    });
  }

  _buildCard(){
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: (){
          if(widget.onTap != null) widget.onTap();
        },
        onTapDown: (_){
         _pressing = true;
        },
        onTapUp: (_){
          _pressing = false;
          if(_dismiss)
            _buildVerticalAniomation(MediaQuery.of(context).padding.top + 5, -(_cardSize.height + 20),Curves.elasticIn, true, widget.millisecondsToDismissAnd);
        },
        onHorizontalDragUpdate: (DragUpdateDetails d){
          _pressing = true;
          setState(() {
            _currentX += d.primaryDelta;
          });
        },
        onHorizontalDragEnd: (DragEndDetails d){
          _pressing = false;
          if(_currentX <= -100 || _currentX >= 100){
            _timeToDismiss.cancel();
            var begin = _currentX;
            var end = MediaQuery.of(context).size.width * (_currentX < 0 ? -1 : 1);
            _buildVerticalAniomation(
              begin, end,Curves.fastLinearToSlowEaseIn, true, widget.millisecondsToDismissAnd, vertical: false); 
          }
          else{
            _buildTimer();
            setState(() {
              _currentX = 0;
            });
          }
        },
        child: Container(
          key: _globalKeyCard,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white.withOpacity(0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(widget.icon),
                  SizedBox(width: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Text(
                      widget.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Text(widget.mensage, textAlign: TextAlign.start)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;
    _animation = null;
    _timeToDismiss?.cancel();
    _timeToDismiss = null;
    _globalKeyCard = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _currentX,
      top: _currentY,
      child: _buildCard(),
    );
  }
}