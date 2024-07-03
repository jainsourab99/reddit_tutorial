import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/Core/Constant/firebase_constant.dart';
import 'package:reddit_tutorial/Core/failure.dart';
import 'package:reddit_tutorial/Core/provider/firebase_provider.dart';
import 'package:reddit_tutorial/Core/type_defs.dart';
import 'package:reddit_tutorial/models/user_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firebase: ref.watch(fireStoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firebase})
      : _firestore = firebase;
  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_user.doc(user.name).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
