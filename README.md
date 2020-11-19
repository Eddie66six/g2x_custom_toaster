# g2x_custom_toaster

## image
<img src="https://raw.githubusercontent.com/Eddie66six/g2x_custom_toaster/master/example/g2x_custom_toaster.gif"/>

## g2x_custom_toaster usage

    G2xCustomToaster.showOnTop(
        icon: Icons.notifications,
        title: "",
        mensage: "",
        navigationKey: _navigationKey,//required navigarionKey(MaterialApp)
        onTap: (){
          //click on notification
        },
        onFinish: (){
          //callback finish
        },
        //animation duration
        millisecondsToDismissStart: 5000 
        millisecondsToDismissAnd
    );