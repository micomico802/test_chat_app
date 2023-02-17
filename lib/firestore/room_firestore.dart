import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_chat_app/firestore/user_firestore.dart';
import 'package:test_chat_app/utils/shared_pref.dart';

import '../model/talk_room.dart';
import '../model/user.dart';

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('room');
  static final joinedRoomSnapshot = _roomCollection
      .where('joined_user_ids', arrayContains: SharedPref.fetchUid())
      .snapshots();

  static Future<void> createRoom(String myUid) async {
    try {
      final docs = await UserFirestore.fetchUsers();
      if (docs == null) return;
      docs.forEach((doc) async {
        if (doc.id == myUid) return;
        await _roomCollection.add({
          'joined_user_ids': [doc.id, myUid],
          'created_time': Timestamp.now()
        });
      });
    } catch (e) {
      print('ルーム作成失敗');
    }
  }

  static Future<List<TalkRoom>?> fetchJoinedRooms(
      QuerySnapshot snapshot) async {
    try {
      String myUid = SharedPref.fetchUid()!;
      List<TalkRoom> talkRooms = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> userIds = data['joined_user_ids'];
        late String talkUserId;
        for (var id in userIds) {
          if (id == myUid) continue;
          talkUserId = id;
        }
        User? talkUser = await UserFirestore.fetchProfile(talkUserId);
        if (talkUser == null) return null;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            talkUser: talkUser,
            lastMessage: data['last_message']);
        talkRooms.add(talkRoom);
      }
      print(talkRooms.length);
      return talkRooms;
    } catch (e) {
      print('参加しているユーザーの取得の失敗　------------- $e');
      return null;
    }
  }

  static Stream<QuerySnapshot> fetchMessageSnapshot(String roomId) {
    return _roomCollection
        .doc(roomId)
        .collection('message')
        .orderBy('send_time', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      {required String roomId, required String message}) async {
    try {
      final messageCollection =
          _roomCollection.doc(roomId).collection('message');
      await messageCollection.add({
        'message': message,
        'sender_id': SharedPref.fetchUid(),
        'send_time': Timestamp.now(),
      });

      _roomCollection.doc(roomId).update({
        'last_message': message,
      });
    } catch (e) {
      print('メッセージ送信失敗 ===== $e');
    }
  }
}
