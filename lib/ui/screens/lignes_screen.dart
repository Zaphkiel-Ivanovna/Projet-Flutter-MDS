// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../../repositories/lignes_repository.dart';

class Lignes extends StatefulWidget {
  final LignesRepository lignesRepository;
  Lignes({Key? key, required this.lignesRepository}) : super(key: key);

  @override
  State<Lignes> createState() => _LigneState();
}

class _LigneState extends State<Lignes> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          children: [
            TextField(
            onChanged: (value) async {
              // if (value.length >= 3) {
              //   final AddressRepository addressRepository = AddressRepository();
              //   // Méthode 1
              //   List<Address> addresses =
              //       await addressRepository.fetchAddresses(value);
              //   setState(() {
              //     _addresses = addresses;
              //   });
              // }
            },
          ),
          Expanded(
            child:
          ListView.separated(itemBuilder:((context, index) {
            return ListTile(
              leading: Text('1'),
              title: Text('fgbrev'),
              trailing: Text('rfgthtr'));
          }), 
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          }, 
          itemCount: 10
          )
          ),
          ],
        )
      );
    }
     void _performSearch() async {
    _lignesData = await widget.lignesRepository.fetchData();
    }
}

