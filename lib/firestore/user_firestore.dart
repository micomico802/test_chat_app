import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_chat_app/firestore/room_firestore.dart';

import '../model/user.dart';
import '../utils/shared_pref.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async {
    try {
      final newDoc = await _userCollection.add({
        'name': 'ななし',
        'image_path': 'https://pbs.twimg.com/profile_images/948451052700934144/BqvpXgXM_400x400.jpg',
      });
    print('アカウント作成完了');
    return newDoc.id;
    } catch(e) {
      print('アカウント作成失敗 ===== $e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await UserFirestore.insertNewAccount();
    if(myUid != null) {
      RoomFirestore.createRoom(myUid);
      SharedPref.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      print('アカウント取得成功');
      return snapshot.docs;
    } catch(e) {
      print('アカウント取得失敗 ===== $e');
      return null;
    }
  }

  static Future<User?> fetchProfile(String uid) async{
    try {
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
        name: snapshot.data()!['name'],
        imagePath: snapshot.data()!['image_path'],
        uid: uid,
      );
      return user;
    } catch(e) {
      print('アカウント取得失敗 ===== $e');
      return null;
    }
  }

}