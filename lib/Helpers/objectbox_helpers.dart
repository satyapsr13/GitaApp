import 'dart:io';

import 'package:gita/objectbox.g.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ObjectboxHelper {
  static ObjectboxHelper? _objectboxHelper;
  static Store? _store;

  ObjectboxHelper._createInstance();

  factory ObjectboxHelper() {
    _objectboxHelper ??= ObjectboxHelper._createInstance();
    return _objectboxHelper!;
  }

  Future<Store> get store async {
    _store = _store ?? await initializeDatabase();
    return _store!;
  }

  Future<Store> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'aeonian_gita_objectbox');
    Future<Store> yufinDatabase;
    try {
      yufinDatabase = openStore(directory: path);
    } on Exception {
      yufinDatabase = Future<Store>(() => _store!);
    }
    return yufinDatabase;
  }

  dispose() {
    _store?.close();
  }

  Future<Box<T>> getBox<T>() async {
    Store localStore = _store!;

    return localStore.box<T>();
  }
}
