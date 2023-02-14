import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<void> createUser() async {
    try {
      await _userCollection.add({
        'name': 'ななし',
        'image_path': 'https://pbs.twimg.com/profile_images/948451052700934144/BqvpXgXM_400x400.jpg',
      });
    print('アカウント作成完了');
    } catch(e) {
      print('アカウント作成失敗 ===== $e');
    }
  }
}