import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/Core/Constant/firebase_constant.dart';
import 'package:reddit_tutorial/Core/failure.dart';
import 'package:reddit_tutorial/Core/provider/firebase_provider.dart';
import 'package:reddit_tutorial/Core/type_defs.dart';
import 'package:reddit_tutorial/models/community_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(fireStoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _community.doc(community.name).get();
      if (communityDoc.exists) {
        throw "Already Exist";
      }

      return right(
        _community.doc(community.name).set(
              community.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  Stream<List<Community>> getUserCommunity(String uid) {
    return _community
        .where("members", arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> community = [];
      for (var doc in event.docs) {
        community.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return community;
    });
  }

  Stream<Community> getCommnumityByName(String name) {
    return _community.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _community =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
