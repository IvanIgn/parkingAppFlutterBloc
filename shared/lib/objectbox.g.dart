// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;

import 'src/models/Parking.dart';
import 'src/models/ParkingSpace.dart';
import 'src/models/Person.dart';
import 'src/models/Vehicle.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(8, 824650823657465954),
      name: 'Parking',
      lastPropertyId: const obx_int.IdUid(5, 1609144784833227752),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 661853388607957574),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3004670141120313326),
            name: 'startTime',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 8257133817936604664),
            name: 'endTime',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 2306328176571228343),
            name: 'vehicleInDb',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 1609144784833227752),
            name: 'parkingSpaceInDb',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(10, 1841873890814069813),
      name: 'Person',
      lastPropertyId: const obx_int.IdUid(3, 2931425440465353621),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5337026217534021947),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1561217851725536718),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2931425440465353621),
            name: 'personNumber',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(11, 5667858591162596226),
      name: 'ParkingSpace',
      lastPropertyId: const obx_int.IdUid(3, 9031271066032574339),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8994559370551354172),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6363267265919254256),
            name: 'address',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 9031271066032574339),
            name: 'pricePerHour',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(12, 6086658373669168151),
      name: 'Vehicle',
      lastPropertyId: const obx_int.IdUid(4, 4671453349956199184),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 2717490048350381919),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3500872604126528215),
            name: 'regNumber',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 160493990998710749),
            name: 'vehicleType',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4671453349956199184),
            name: 'ownerInDb',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
obx.Store openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) {
  return obx.Store(getObjectBoxModel(),
      directory: directory,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(12, 6086658373669168151),
      lastIndexId: const obx_int.IdUid(4, 4798284582577413301),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [
        965152471072294254,
        8620411946582457575,
        6258382579173369036,
        2901661101577721036,
        1519859493253967796,
        7191138785108492133,
        8933583816771875440,
        1161205363529624153
      ],
      retiredIndexUids: const [5564003874537992562, 4798284582577413301],
      retiredPropertyUids: const [
        8366330658814183735,
        5600131646149710494,
        1866870151261422822,
        1492191045718476066,
        3593522772414764062,
        8103166605134966733,
        9011149109643117725,
        5193122545111592706,
        7285563221192134133,
        8641516416030137104,
        3337318876874822512,
        7051891498731239499,
        2998436982810254675,
        5608798301651552547,
        877381720583930468,
        6799819872449346629,
        7494013658001642964,
        3254844371935294095,
        812508039628900891,
        4242949273463350338,
        7519299589982298602,
        3172108121565194504,
        3312992273821872827,
        8106389169893168790,
        8781902282256905811,
        8271691605054250781,
        5306954156578879582,
        3733505355541841149,
        6915302794006349390
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Parking: obx_int.EntityDefinition<Parking>(
        model: _entities[0],
        toOneRelations: (Parking object) => [],
        toManyRelations: (Parking object) => {},
        getId: (Parking object) => object.id,
        setId: (Parking object, int id) {
          object.id = id;
        },
        objectToFB: (Parking object, fb.Builder fbb) {
          final vehicleInDbOffset = object.vehicleInDb == null
              ? null
              : fbb.writeString(object.vehicleInDb!);
          final parkingSpaceInDbOffset = object.parkingSpaceInDb == null
              ? null
              : fbb.writeString(object.parkingSpaceInDb!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.startTime.millisecondsSinceEpoch);
          fbb.addInt64(2, object.endTime.millisecondsSinceEpoch);
          fbb.addOffset(3, vehicleInDbOffset);
          fbb.addOffset(4, parkingSpaceInDbOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final startTimeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final endTimeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final object = Parking(
              startTime: startTimeParam, endTime: endTimeParam, id: idParam)
            ..vehicleInDb = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10)
            ..parkingSpaceInDb = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 12);

          return object;
        }),
    Person: obx_int.EntityDefinition<Person>(
        model: _entities[1],
        toOneRelations: (Person object) => [],
        toManyRelations: (Person object) => {},
        getId: (Person object) => object.id,
        setId: (Person object, int id) {
          object.id = id;
        },
        objectToFB: (Person object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final personNumberOffset = fbb.writeString(object.personNumber);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, personNumberOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final personNumberParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, '');
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final object = Person(
              name: nameParam, personNumber: personNumberParam, id: idParam);

          return object;
        }),
    ParkingSpace: obx_int.EntityDefinition<ParkingSpace>(
        model: _entities[2],
        toOneRelations: (ParkingSpace object) => [],
        toManyRelations: (ParkingSpace object) => {},
        getId: (ParkingSpace object) => object.id,
        setId: (ParkingSpace object, int id) {
          object.id = id;
        },
        objectToFB: (ParkingSpace object, fb.Builder fbb) {
          final addressOffset = fbb.writeString(object.address);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, addressOffset);
          fbb.addInt64(2, object.pricePerHour);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final addressParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final pricePerHourParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final object = ParkingSpace(
              address: addressParam,
              pricePerHour: pricePerHourParam,
              id: idParam);

          return object;
        }),
    Vehicle: obx_int.EntityDefinition<Vehicle>(
        model: _entities[3],
        toOneRelations: (Vehicle object) => [],
        toManyRelations: (Vehicle object) => {},
        getId: (Vehicle object) => object.id,
        setId: (Vehicle object, int id) {
          object.id = id;
        },
        objectToFB: (Vehicle object, fb.Builder fbb) {
          final regNumberOffset = fbb.writeString(object.regNumber);
          final vehicleTypeOffset = fbb.writeString(object.vehicleType);
          final ownerInDbOffset = object.ownerInDb == null
              ? null
              : fbb.writeString(object.ownerInDb!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, regNumberOffset);
          fbb.addOffset(2, vehicleTypeOffset);
          fbb.addOffset(3, ownerInDbOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final regNumberParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final vehicleTypeParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, '');
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final object = Vehicle(
              regNumber: regNumberParam,
              vehicleType: vehicleTypeParam,
              id: idParam)
            ..ownerInDb = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Parking] entity fields to define ObjectBox queries.
class Parking_ {
  /// See [Parking.id].
  static final id =
      obx.QueryIntegerProperty<Parking>(_entities[0].properties[0]);

  /// See [Parking.startTime].
  static final startTime =
      obx.QueryDateProperty<Parking>(_entities[0].properties[1]);

  /// See [Parking.endTime].
  static final endTime =
      obx.QueryDateProperty<Parking>(_entities[0].properties[2]);

  /// See [Parking.vehicleInDb].
  static final vehicleInDb =
      obx.QueryStringProperty<Parking>(_entities[0].properties[3]);

  /// See [Parking.parkingSpaceInDb].
  static final parkingSpaceInDb =
      obx.QueryStringProperty<Parking>(_entities[0].properties[4]);
}

/// [Person] entity fields to define ObjectBox queries.
class Person_ {
  /// See [Person.id].
  static final id =
      obx.QueryIntegerProperty<Person>(_entities[1].properties[0]);

  /// See [Person.name].
  static final name =
      obx.QueryStringProperty<Person>(_entities[1].properties[1]);

  /// See [Person.personNumber].
  static final personNumber =
      obx.QueryStringProperty<Person>(_entities[1].properties[2]);
}

/// [ParkingSpace] entity fields to define ObjectBox queries.
class ParkingSpace_ {
  /// See [ParkingSpace.id].
  static final id =
      obx.QueryIntegerProperty<ParkingSpace>(_entities[2].properties[0]);

  /// See [ParkingSpace.address].
  static final address =
      obx.QueryStringProperty<ParkingSpace>(_entities[2].properties[1]);

  /// See [ParkingSpace.pricePerHour].
  static final pricePerHour =
      obx.QueryIntegerProperty<ParkingSpace>(_entities[2].properties[2]);
}

/// [Vehicle] entity fields to define ObjectBox queries.
class Vehicle_ {
  /// See [Vehicle.id].
  static final id =
      obx.QueryIntegerProperty<Vehicle>(_entities[3].properties[0]);

  /// See [Vehicle.regNumber].
  static final regNumber =
      obx.QueryStringProperty<Vehicle>(_entities[3].properties[1]);

  /// See [Vehicle.vehicleType].
  static final vehicleType =
      obx.QueryStringProperty<Vehicle>(_entities[3].properties[2]);

  /// See [Vehicle.ownerInDb].
  static final ownerInDb =
      obx.QueryStringProperty<Vehicle>(_entities[3].properties[3]);
}
