import 'package:flutter/material.dart';
import 'package:tt/components/base_route.dart';
import 'package:tt/helpers/resources.dart';

// Copyright (c) 2023, Devon Carew. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;
import 'package:vtable/vtable.dart';

class Purchase extends StatefulWidget {
  Purchase({super.key});
  final items = generateRowData(planets.length * 10);

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  Widget build(BuildContext context) {
    return BaseRout(
      routeName: "shit",
      child: Center(
        child: createTable(),
      ),
    );
  }

  VTable createTable() {
    var width = MediaQuery.of(context).size.width;
    const disabledStyle =
        TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);

    return VTable<SampleRowData>(
      filterWidgets: [Icon(Icons.home_outlined)],
      items: widget.items,
      tableDescription: '${widget.items.length} items',
      startsSorted: true,
      includeCopyToClipboardAction: true,
      columns: [
        VTableColumn(
            label: resNumber,
            width: (width * 2 / 12).round(),
            compareFunction: null,
            transformFunction: (row) => row.id,
            icon: Icons.numbers),
        VTableColumn(
          label: resDate,
          width: (width * 3 / 12).round(),
          grow: 1,
          transformFunction: (row) => row.planet.name,
          styleFunction: (row) => row.planet == moon ? disabledStyle : null,
        ),
        VTableColumn(
          label: resName,
          width: (width * 4 / 12).round(),
          transformFunction: (row) => row.planet.gravity.toStringAsFixed(1),
          alignment: Alignment.centerRight,
          compareFunction: (a, b) =>
              a.planet.gravity.compareTo(b.planet.gravity),
          validators: [SampleRowData.validateGravity],
        ),
        VTableColumn(
          label: resAmount,
          width: (width * 3 / 12).round(),
          alignment: Alignment.center,
          transformFunction: (row) => row.planet.temp.toString(),
          compareFunction: (a, b) => a.planet.temp - b.planet.temp,
          renderFunction: (context, data, _) {
            Color color;
            if (data.planet.temp < 0) {
              color = Colors.blue
                  .withAlpha((data.planet.temp / Planet.coldest * 255).round());
            } else {
              color = Colors.red
                  .withAlpha((data.planet.temp / Planet.hotest * 255).round());
            }
            return Chip(
              label: const SizedBox(width: 48),
              backgroundColor: color,
            );
          },
        ),
      ],
    );
  }
}

List<SampleRowData> generateRowData(int rows) {
  final words = loremIpsum
      .toLowerCase()
      .replaceAll(',', '')
      .replaceAll('.', '')
      .split(' ');
  final random = math.Random();

  return List.generate(rows, (index) {
    final word1 = words[random.nextInt(words.length)];
    final word2 = words[random.nextInt(words.length)];
    final val = random.nextInt(10000);
    final id = '$word1-$word2-${val.toString().padLeft(4, '0')}';

    return SampleRowData(
      id: id,
      planet: planets[random.nextInt(planets.length)],
    );
  });
}

const String loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua.';

const Planet earth = Planet('Earth', 9.8, 149.6, 365.2, 15, 1);
const Planet moon = Planet('Moon', 1.6, 0.384, 27.3, -20, 0);

const List<Planet> planets = <Planet>[
  Planet('Mercury', 3.7, 57.9, 88, 167, 0),
  Planet('Venus', 8.9, 108.2, 224.7, 464, 0),
  earth,
  moon,
  Planet('Mars', 3.7, 228, 687, -65, 2),
  Planet('Jupiter', 23.1, 778.5, 4331, -110, 92),
  Planet('Saturn', 9, 1432, 10747, -140, 83),
  Planet('Uranus', 8.7, 2867, 30589, -195, 27),
  Planet('Neptune', 11, 4515, 59800, -200, 14),
  Planet('Pluto', 0.7, 5906.4, 90560, -225, 5),
];

class Planet {
  final String name;
  final double gravity;
  final double orbit;
  final double period;
  final int temp;
  final int moons;

  const Planet(
    this.name,
    this.gravity,
    this.orbit,
    this.period,
    this.temp,
    this.moons,
  );

  static int get coldest =>
      planets.fold(0, (previous, next) => math.min(previous, next.temp));

  static int get hotest =>
      planets.fold(0, (previous, next) => math.max(previous, next.temp));

  @override
  String toString() => name;
}

class SampleRowData {
  final String id;
  final Planet planet;

  SampleRowData({required this.id, required this.planet});

  static ValidationResult? validateGravity(SampleRowData row) {
    if (row.planet.gravity > 20.0) {
      return ValidationResult.error('too heavy!');
    }
    if (row.planet.gravity > 10.0) {
      return ValidationResult.warning('pretty heavy');
    }
    return null;
  }

  @override
  String toString() => '$id (${planet.name})';
}
