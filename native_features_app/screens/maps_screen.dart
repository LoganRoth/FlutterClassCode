import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialLocation = const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
      ),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLoc;

  void _selectLoc(LatLng pos) {
    setState(() {
      _pickedLoc = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLoc == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLoc);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
          onTap: widget.isSelecting ? _selectLoc : null,
          markers: ((_pickedLoc == null) && (widget.isSelecting))
              ? null
              : {
                  Marker(
                    markedId: MarkerId('m1'),
                    position: _pickedLoc ??
                        LatLng(
                          widget.initialLocation.latitude,
                          widget.initialLocation.longitude,
                        ),
                  ),
                },
        ),
      ),
    );
  }
}