import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  final GeoPoint campPosition;
  final Map trekData;
  GoogleMapScreen({@required this.campPosition, @required this.trekData});
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: {
              Marker(
                  markerId: MarkerId('111'),
                  position: LatLng(widget.campPosition.latitude,
                      widget.campPosition.longitude),
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: InfoWindow(
                      title: widget.trekData['name'],
                      snippet: '${widget.trekData['altitude']} ft'))
            },
            mapType: MapType.terrain,
            compassEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.campPosition.latitude,
                    widget.campPosition.longitude),
                zoom: 6.0),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 56.0, left: 20.0),
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.15),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: Offset(5, 5))
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
