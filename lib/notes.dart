// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {



  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }




  void showNotification(String name, String sname){
    setState(() {

    });
    flutterLocalNotificationsPlugin.show(
        0,
        name,
        sname,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
        ),
    );
  }

  final CollectionReference reff = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("nots");

  final TextEditingController namecontrolar = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController searchControl = TextEditingController();
  var _height = 50.0;
  var _wigth = 50.0;

  bool tap = true;

  String name = "";

  List searchResult = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: SafeArea(
          child: Scaffold(
            drawer: Drawer(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              "${user.email}",
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                            Spacer(),
                            ElevatedButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                child: const Text("Sign out")),
                            Spacer(),
                          ],
                        ),
                      ),
                    )),
                    Expanded(child: Container(),flex: 15,)
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.amber,
                  statusBarBrightness: Brightness.dark
              ),
              title: const Text('Notes'),
              // centerTitle: true,
              actions: [
                GestureDetector(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.bounceOut,
                    height: _height,
                    width: _wigth,
                    // color: Colors.blue,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                  tap ? Icons.search :Icons.home
                              ),
                              onPressed: () {
                                setState(() {
                                  if (tap == true) {
                                    _wigth = MediaQuery.of(context).size.width * 0.75;
                                    tap = false;
                                  } else if (tap == false) {
                                    tap = true;
                                    _wigth = 50;
                                  }
                                });
                              },
                            ),

                            // ==================-+========       search textfield

                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 2),
                                  child: TextField(
                                    controller: searchControl,
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (quiry) {
                                      setState(() {
                                        search_(quiry);
                                      });
                                    },
                                  ),
                                ))
                          ],
                        )),
                    // color: Colors.blue,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showNotification("onPressed","Plush");
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
            body: tap
                ? StreamBuilder<QuerySnapshot>(
              stream: reff.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];

                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index]["name"]),
                          leading: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                update_(documentSnapshot);
                              }),
                          trailing: IconButton(
                            onPressed: () async {
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Are you sure !!!"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              reff
                                                  .doc(documentSnapshot.id)
                                                  .delete();
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Delete")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"))
                                      ],
                                    );
                                  },
                                );
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
                : ListView.builder(
              itemBuilder: (context, index) {

                return Card(
                  child: ListTile(
                    title: Text(searchResult[index]["name"]),
                    leading: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // update_(documentSnapshot);
                        }),
                    trailing: IconButton(
                      onPressed: () async {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Are you sure !!!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        // reff.doc(reff.snapshots.data)
                                        //     .delete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"))
                                ],
                              );
                            },
                          );
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
              itemCount: searchResult.length,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                add_();
                namecontrolar.text = "";
              },
              child: const Icon(Icons.add),
            ),
          )),
    );
  }

  Future<void> search_(String quiry) async {
    final result = await FirebaseFirestore.instance
        .collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("nots")
        .where("name", isEqualTo: quiry)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  Future<void> update_(DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot != null) {
      namecontrolar.text = documentSnapshot["name"];
    }

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: TextField(
                controller: namecontrolar,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )),
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final name = namecontrolar.text;

                  if (name != null) {
                    await reff.doc(documentSnapshot.id).update({"name": name});
                    namecontrolar.text = "";
                  }
                },
                child: const Text('Edit'))
          ],
        );
      },
    );
  }

  Future<void> add_() async {
            // FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("nots");
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: TextField(
                controller: namecontrolar,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )),
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String name_ = namecontrolar.text;

                  // notificationservice.sendNotification(
                  //     "${namecontrolar.text}", "hello Friends");

                  showNotification(namecontrolar.text,"hello, $name_");

                  if (name_ != null) {
                    await reff.add({"name": name_});
                    namecontrolar.text = "";
                  }
                },
                child: const Text('Save')),

          ],
        );
      },
    );
  }
}
