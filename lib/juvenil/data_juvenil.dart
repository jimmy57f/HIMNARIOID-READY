// data.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'alabanza_juvenil.dart';

Future<List<Juvenil>> fetchAlabanzasJuveniles() async {
  String jsonString = await rootBundle.loadString('assets/juvenil.json');
  List<dynamic> jsonList = json.decode(jsonString);

  List<Juvenil> alabanzas =
      jsonList.map((json) => Juvenil.fromJson(json)).toList();

  return alabanzas;
}
