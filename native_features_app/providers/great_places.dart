import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation pickedLoc,
  ) async {
    final addy = await LocationHelper.getPlaceAddress(
        pickedLoc.latitude, pickedLoc.longitude);
    final updatedLoc = PlaceLocation(
      latitude: pickedLoc.latitude,
      longitude: pickedLoc.longitude,
      address: addy,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: updatedLoc,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insertGP({
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_long': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_long'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
