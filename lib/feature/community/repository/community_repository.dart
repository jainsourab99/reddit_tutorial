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

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_community.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userID) async {
    try {
      return right(_community.doc(communityName).update({
        "members": FieldValue.arrayUnion([userID])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userID) async {
    try {
      return right(_community.doc(communityName).update({
        "members": FieldValue.arrayRemove([userID])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _community
        .where(
          "name",
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities
            .add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_community.doc(communityName).update({
        "mods": uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _community =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
