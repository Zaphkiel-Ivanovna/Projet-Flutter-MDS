import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lignes.dart';
import '../repositories/lignes_repository.dart';

enum ListMode { LIST, SEARCH }

final listModeProviderState = StateProvider<ListMode>((_) => ListMode.LIST);

final listModePorvider = Provider<ListMode>((ref) {
  final ListMode sortType = ref.watch(listModeProviderState);

  switch (sortType) {
    case ListMode.LIST:
      return ListMode.LIST;

    case ListMode.SEARCH:
      return ListMode.SEARCH;
  }
});

final loadLignesPoint = FutureProvider<List<Lignes>>((ref) async {
  LignesRepository lignes = LignesRepository();
  return await lignes.fetchData();
});

final lignesProvider =
    StateNotifierProvider<Lignesnotifier, List<Lignes>>((ref) {
  return Lignesnotifier();
});

class Lignesnotifier extends StateNotifier<List<Lignes>> {
  Lignesnotifier() : super([]);

  //passer les preference en tant que liste initial

  void add(Lignes lignes) {
    saveAdr(lignes);
    state = [...state, lignes];
  }

  void addListAdr(List<Lignes> lignes) {
    state = lignes;
  }

  void remove(Lignes lignes, int index) {
    deleteAdr(index);
    state = [
      for (final lgn in state)
        if (lgn.route_long_name != lignes.route_long_name) lgn,
    ];
  }

  void getLignes() async {
    List<Lignes> lignesList = await getPoint();
    state = lignesList;
  }
}

List<String> listJson = [];

getPoint() async {
  List<Lignes> lignesList = [];
  Map<String, dynamic> decode = {};
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  listJson = prefs.getStringList("lignes")!.toList();
  if (listJson.length != 0) {
    for (int i = 0; i < listJson.length; i++) {
      decode = jsonDecode(listJson[i]);
      lignesList.add(Lignes.fromtest(decode));
    }
  }
  return lignesList;
}

Future<void> saveAdr(Lignes lignes) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getStringList("lignes") == null) {
    listJson.add(jsonEncode(lignes.toJson()));
  } else {
    listJson = prefs.getStringList("lignes")!;
    listJson.add(jsonEncode(lignes.toJson()));
  }
  prefs.setStringList('lignes', listJson);
}

Future<void> deleteAdr(int lignesIndex) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  listJson = prefs.getStringList('lignes')!;
  listJson.removeAt(lignesIndex);
  prefs.setStringList('lignes', listJson);
}
