import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herewego/provider/lignes_provider.dart';
import 'package:herewego/ui/screens/itinerary_screen.dart';
import 'package:latlong2/latlong.dart';
import '../../repositories/lignes_repository.dart';
import '../../models/lignes.dart';

class LignesWidget extends ConsumerStatefulWidget {
  const LignesWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LignesWidgetState();
}

class LignesWidgetState extends ConsumerState {
  List<Lignes> _lignes = [];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ListMode mode = ref.watch(listModeProviderState);
    final getData = ref.watch(loadLignesPoint);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text('Lignes de transport'),
      ),
      body: Container(
        color: const Color(0xFFF2F2F2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Rechercher une ligne',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: mode == ListMode.SEARCH
                      ? IconButton(
                          onPressed: () {
                            controller.clear();
                            ref
                                .watch(listModeProviderState.notifier)
                                .update((state) => ListMode.LIST);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) async {
                  if (value.isEmpty) {
                    ref
                        .watch(listModeProviderState.notifier)
                        .update((state) => ListMode.LIST);
                  } else {
                    ref
                        .watch(listModeProviderState.notifier)
                        .update((state) => ListMode.SEARCH);
                  }
                  final LignesRepository lignesRepo = LignesRepository();
                  List<Lignes> lignesList = await lignesRepo.searchData(value);
                  setState(() {
                    _lignes = lignesList;
                  });
                },
              ),
            ),
            Expanded(
              child: mode == ListMode.LIST
                  ? getData.when(
                      data: (data) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        '0xFF${data[index].route_color}')),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: FittedBox(
                                        child: Text(
                                          data[index].route_id.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(data[index].route_long_name),
                                trailing: IconButton(
                                  onPressed: () {
                                    ref
                                        .watch(lignesProvider.notifier)
                                        .add(data[index]);
                                  },
                                  icon: const Icon(Icons.favorite),
                                ),
                                onTap: () {
                                  var coordinates = data[index]
                                      .coordinates
                                      .map((coordsList) => coordsList
                                          .map((coords) =>
                                              LatLng(coords[1], coords[0]))
                                          .toList())
                                      .toList();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItineraryScreen(
                                        coordinates: coordinates,
                                        ligneName: data[index].route_long_name,
                                        routeColor: data[index].route_color,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 8);
                          },
                          itemCount: data.length,
                        );
                      },
                      error: (Object error, StackTrace stackTrace) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    '0xFF${_lignes[index].route_color}')),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  _lignes[index].route_short_name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(_lignes[index].route_long_name),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: _lignes.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
