import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/Core/failure.dart';
import 'package:reddit_tutorial/Core/provider/firebase_provider.dart';
import 'package:reddit_tutorial/Core/type_defs.dart';

final firebaseStorageProvider = Provider(
  (ref) => StorageRepository(
    storage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage storage})
      : _firebaseStorage = storage;

  FutureEither<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);

      final snapShot = await uploadTask;
      return right(await snapShot.ref.getDownloadURL());
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
