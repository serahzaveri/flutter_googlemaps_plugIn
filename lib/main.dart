import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PlugIn for google maps intergation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String address = '1430 City Councillor, Montreal, Quebec, Canada';
  LatLng _centerLatLng;
  Completer<GoogleMapController> _completer;

  //this change
  String getAddress() {
    return this.address;
  }

  void _calculateLatAndLng(){
    _centerLatLng = LatLng(45.5048, -73.5772);
    Geolocator().placemarkFromAddress(getAddress()).then((placemarks) {
      placemarks.forEach((placemark) {
        setState(() {
          _centerLatLng = LatLng(placemark.position.latitude, placemark.position.longitude);
        });
      });
    });
  }

  @override
  void initState() {
    _completer = Completer();
    _calculateLatAndLng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter PlugIn for integrating Google Maps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 10, 20),
              child: Text(
                'Location - sample address below',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text(
                address,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _completer.complete(controller);
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _centerLatLng,
                  zoom: 13,
                ),
                markers: <Marker> {
                  Marker(
                      markerId: MarkerId('Home Location'),
                      position: _centerLatLng,
                      icon: BitmapDescriptor.defaultMarker
                  ),
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
