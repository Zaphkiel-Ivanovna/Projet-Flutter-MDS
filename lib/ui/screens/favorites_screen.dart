import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/lignes_provider.dart';

class Favorite extends ConsumerWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(lignesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text('Lignes favorites'),
      ),
      body: list.isEmpty // Vérifier si la liste est vide
          ? Center(
              child:
                  Text('Vous n\'avez pas encore ajouté de lignes en favoris.'),
            )
          : ListView.separated(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color:
                            Color(int.parse('0xFF${list[index].route_color}')),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: FittedBox(
                            child: Text(
                              list[index].route_id.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(list[index].route_long_name),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(lignesProvider.notifier)
                            .remove(list[index], index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 0);
              },
            ),
    );
  }
}
