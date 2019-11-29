import 'dart:io';

import 'package:candi/screens/screens.dart';
import 'package:candi/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../src/location.dart' as locations;

class MapAppliants extends StatefulWidget {
  final List<UserLocation> appliants;

  MapAppliants({this.appliants});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapAppliants> {
  BitmapDescriptor myIcon;
  final Map<String, Marker> _markers = {};
  PanelController pcontainer = new PanelController();
  UserLocation singleUser = new UserLocation();

  //INIT CUSTOM MARKER
  @override
  void initState() {
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)), 'avatar-map.png')
          .then((onValue) {
        myIcon = onValue;
      });
      super.initState();
  }

  _handleTapboxChanged(UserLocation newValue) {
    setState(() {
      singleUser = newValue;
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
      for (final appliant in widget.appliants) {

        final marker = Marker(
          icon: myIcon,
          markerId: MarkerId(appliant.name),
          position: LatLng(appliant.lat.toDouble(), appliant.lng.toDouble()),
          onTap: () {
            showFancyCustomDialog(context, appliant);
            //pcontainer.open();
            //_handleTapboxChanged(appliant);
            //ListPage(singleUser: appliant);
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(userLocation: appliants)));*/
          },
          infoWindow: InfoWindow(
            title: appliant.name,
            snippet: appliant.address,
          ),
        );
        _markers[appliant.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context){
        return Scaffold(

          body: SlidingUpPanel(
                color: Colors.transparent,
                defaultPanelState: PanelState.CLOSED,
                controller: pcontainer,
                minHeight: 50,
                maxHeight: 400,
                backdropEnabled: false,
                backdropOpacity: 0,
                //borderRadius: radius,
                panel: Padding(
                  padding: EdgeInsets.all(8),
                  child:
                   ListPage(title: 'Profiles', singleUser: singleUser)),
                collapsed: Container(
                  decoration:
                      BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text(
                      'Voir les profiles',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                body: Scaffold(
                  //drawer: TopicDrawer(topics: snap.data),
                  //MapAppliants(appliants: snap.data, pcontainer: pcontainer),
                  body: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: const LatLng(44.8333, -0.5667),
                      zoom: 13,
                    ),
                    markers: _markers.values.toSet(),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      if (pcontainer.isPanelClosed()) {
                        pcontainer.open();
                      } else {
                        pcontainer.close();
                      }
                    },
                    tooltip: 'Increment',
                    child: Icon(Icons.add),
                    backgroundColor: Colors.blueGrey[900],
                    mini: false,
                    isExtended: true,
                  ),
                )
              ),


          /*body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: const LatLng(44.8333, -0.5667),
              zoom: 13,
            ),
            markers: _markers.values.toSet(),
          ),*/
      );

      Future <BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
        ImageConfiguration configuration = ImageConfiguration();
          BitmapDescriptor bmpd = await BitmapDescriptor.fromAssetImage(
            configuration, iconPath);
        return bmpd;
      }
    }
  }


  void showFancyCustomDialog(BuildContext context, UserLocation user) {
  Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                user.name,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Taux de compatibilité",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: user.indicatorValue.toDouble(),
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Il me plait',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.purpleAccent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Profil',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  showDialog(context: context, builder: (BuildContext context) => simpleDialog);
}

//Motor of enter/exit modal
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}