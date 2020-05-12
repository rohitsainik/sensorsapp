import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class BallGame extends StatefulWidget {
  @override
  _BallGameState createState() => _BallGameState();
}

class _BallGameState extends State<BallGame> {
  // color of the circle
  Color color = Colors.red;

  // event returned from accelerometer stream
  AccelerometerEvent event;

  // hold a refernce to these, so that they can be disposed
  Timer timer;
  StreamSubscription accel;

  // positions and count
  double top = 125;
  double left=180;
  int count = 0;

  // variables for screen size
  double width;
  double height;

  setColor(AccelerometerEvent event) {

    if ( event.x > 9 || event.y > 9 || -9 > event.x || -9> event.y  ) {
      // set the color and increment count
      setState(() {
        color = Colors.red;
      });
    } else {
      // set the color and restart count
      setState(() {
        color = Colors.green;
      });
    }
  }

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }
    setState(() {
      left = ((event.x * 20) + 160);
    });
    setState(() {
      top = event.y * 20 + 200;
    });
  }


  startTimer() {
    if (accel == null) {
      accel = accelerometerEvents.listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
        });
      });
    } else {
      accel.resume();
    }

    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(milliseconds: 200), (_) {
        if (count > 3) {
          pauseTimer();
        } else {
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    timer.cancel();
    accel.pause();

    setState(() {
      color = Colors.red;
    });
  }


  @override
  void dispose() {
    timer?.cancel();
    accel?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the width and height of the screen
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(

      body: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              // This empty container is given a width and height to set the size of the stack
              Container(
                height: height/1.5,
                width: width,
                color: Colors.blue,
              ),
              Positioned(
                top: top,
                left: left ?? 160,
                // the container has a color and is wrappeed in a ClipOval to make it round
                child: ClipOval(
                  child: Container(
                    width: 80,
                    height: 80,
                    color: color,
                  ),
                ),
              ),

            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RaisedButton(
              splashColor: Colors.red,
              highlightColor: Colors.red,
              onPressed: startTimer,
              child: Text('Begin'),
              color: Colors.green,
              textColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
//          showpos(event)

        ],
      ),
    );

  }
//  Widget showpos(AccelerometerEvent event){
//    if(event.x== null){if(event.x > 9 || event.y > 9 || -9 > event.x || -9> event.y){
//      return  Text("Ball has Touched the Wall", style: TextStyle(color: Colors.red,fontSize: 30.0,fontWeight: FontWeight.bold),);
//    }
//    else{
//      return  Text("Ball is Inside Wall", style: TextStyle(color: Colors.green,fontSize: 30.0,fontWeight: FontWeight.bold),);
//    }
//
//  }else{
//      return  Text("start", style: TextStyle(color: Colors.green,fontSize: 30.0,fontWeight: FontWeight.bold),);
//    }
//  }



}