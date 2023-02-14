import 'package:flutter/material.dart';
import 'package:test_chat_app/pages/setting_profile_page.dart';
import 'package:test_chat_app/pages/talk_room_page.dart';

import '../model/user.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<User> userList = [
    User(
        name: '水本',
        uid: '001',
        imagePath:
        'https://pbs.twimg.com/profile_images/1590340931256926208/B6QscRNo_400x400.jpg',
        lastMessage: 'こんにちは'),
    User(
        name: '佐藤',
        uid: '002',
        imagePath:
        'https://pbs.twimg.com/profile_images/1510253126984810505/wMksF0iu_400x400.jpg',
        lastMessage: 'arigato'),
    User(
        name: '今村',
        uid: '003',
        imagePath:
        'https://pbs.twimg.com/profile_images/948451052700934144/BqvpXgXM_400x400.jpg',
        lastMessage: 'どうも'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('チャットアプリTop')),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>const SettingProfilePage()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                print('タップ検知');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TalkRoomPage(userList[index].name)));
              },
              child: SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                          radius: 30,
                          backgroundImage: userList[index].imagePath == null
                              ? null
                              : NetworkImage(userList[index].imagePath!)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userList[index].name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(userList[index].lastMessage,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
