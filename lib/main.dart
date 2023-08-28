
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const GpsLocation());
}


class GpsLocation extends StatelessWidget {
  const GpsLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  LocationData? mycurrentlocation;
  late StreamSubscription _streamSubscription;

  Future<void> getmylocation() async {
    Location.instance.requestPermission().then((value) => print(value));
    Location.instance.hasPermission().then((value) => print(value));
      mycurrentlocation = await Location.instance.getLocation();
      print(mycurrentlocation);
      if(mounted){
        setState(() {
        });
      }
  }

  void listenTomylocation(){
    _streamSubscription =  Location.instance.onLocationChanged.listen((location) {
      if(location !=mycurrentlocation){
        mycurrentlocation = location;
        print(location);
        if(mounted){
          setState(() {
          });
        }
      }

    });
  }

  void canclelocation(){
    _streamSubscription.cancel();
  }


  void initialize(){
    Location.instance.changeSettings(
      distanceFilter: 10,
      accuracy: LocationAccuracy.high,
      interval: 3000
    );
  }

  @override
  void initState() {
    initialize();
    getmylocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gps Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${mycurrentlocation?.latitude}',style: TextStyle(fontSize: 30),),
            Text('${mycurrentlocation?.longitude}',style: TextStyle(fontSize: 30),),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(onPressed: (){
            getmylocation();
          },child: Icon(Icons.my_location),),
          FloatingActionButton(onPressed: (){
            listenTomylocation();
          },child: Icon(Icons.location_history),),
          FloatingActionButton(onPressed: (){
            canclelocation();
          },child: Icon(Icons.stop_circle),),
        ],
      ),
    );
  }
}

