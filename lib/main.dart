import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/bloc_withchat/chat_bloc.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = Firestore.instance;
  final TextEditingController _textController = new TextEditingController();
  final ScrollController scrollController = ScrollController();
  final messageBloc = MessageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Application"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: messageBloc.textStream,
          builder: (ctxt, AsyncSnapshot<String> textStream) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: db.collection('textmessages').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );

                        List<DocumentSnapshot> docs = snapshot.data.documents;

                        List<Widget> messages = docs
                            .map((doc) => Message(
                                text: doc.data['textMessage'],
                                timing: DateFormat.jm().format(doc.data['timing']),
                                deviceId: messageBloc.deviceId == doc.data['deviceId']))
                            .toList();
                        return ListView(
                          controller: scrollController,
                          children: messages,
                        );
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            //onSubmitted: (value) => callback(),
                            decoration: InputDecoration(
                              hintText: "Enter a Message...",
                              border: const OutlineInputBorder(),
                            ),
                            controller: _textController,
                            onChanged: (String txt) {
                              messageBloc.updateText(txt);
                            },
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              messageBloc.updateCurrentTime(
                                  Timestamp.fromDate(DateTime.now()));
                              messageBloc.updateDeviceid(await DeviceId.getID);
                              _textController.clear();
                              DocumentReference ref =
                                  await db.collection("textmessages").add({
                                "textMessage": messageBloc.message,
                                "timing": messageBloc.currentTime,
                                "deviceId": messageBloc.deviceId
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final timing;
  final bool deviceId;
  const Message({Key key, this.text, this.timing, this.deviceId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: deviceId
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 6.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 130,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Text(
                            text,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Text(timing,
                      style: TextStyle(color: Colors.black, fontSize: 15.0)),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 6.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 130,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Text(
                            text,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Text('$timing',
                      style: TextStyle(color: Colors.black, fontSize: 15.0)),
                ),
              ],
            ),
    );
  }
}

//class HomeScreen extends StatefulWidget {
//  @override
//  _HomeScreenState createState() => _HomeScreenState();
//}
//
//class _HomeScreenState extends State<HomeScreen> {
//  var db = Firestore.instance;
//  final TextEditingController _textController = new TextEditingController();
//  final ScrollController scrollController = ScrollController();
//  final messageBloc = MessageBloc();
//  double c_width;
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//        appBar: new AppBar(
//          title: new Text("Chat Application"),
//          centerTitle: true,
//
//        ),
//        body: StreamBuilder(
//            stream: messageBloc.textStream,
//            builder: (ctxt, AsyncSnapshot<String> textStream){
//              return SafeArea(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Expanded(
//                      child: StreamBuilder<QuerySnapshot>(
//                   stream: db.collection('textmessages').snapshots(),
//                        builder: (context, snapshot) {
//                          if (!snapshot.hasData)
//                            return Center(
//                              child: CircularProgressIndicator(),
//                            );
//                          List<DocumentSnapshot> docs = snapshot.data.documents;
//                          List<Widget> messages = docs.map(
//                                  (doc) =>
//                                  Message(
//                                    text: doc.data['textMessage'],
//                                      timing:DateFormat.jm().format(doc.data['timing']),
//                                      deviceId : messageBloc.deviceId==doc.data['deviceId']
//
//                                  )
//                          ).toList();
//                          return ListView(
//                            controller: scrollController,
//                            children: messages,
//                          );
//                        },
//                      ),
//                    ),
//                    Container(
//                      child: Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: TextField(
//                              decoration: InputDecoration(
//                                hintText: "Enter a Message...",
//                                border: const OutlineInputBorder(),
//                              ),
//                              controller: _textController,
//                              onChanged: (String txt) {
//                                messageBloc.updateText(txt);
//                              },
//                              maxLines: null,
//                            ),
//                          ),
//                          IconButton(icon: Icon(Icons.send), onPressed: () async {
//
//                            messageBloc.updateCurrentTime(Timestamp.fromDate(DateTime.now()));
//                            messageBloc.updateDeviceid( await DeviceId.getID);
//                            print("Message bloc :" + messageBloc.deviceId);
//                            _textController.clear();
//                            DocumentReference ref = await db
//                                .collection("textmessages")
//                                .add({"textMessage": messageBloc.message,
//                              "timing": messageBloc.currentTime,
//                            "deviceId" : messageBloc.deviceId});
//                          }),
//
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              );
//            }
//        )
//    );
//  }
//}
//
//
//class Message extends StatelessWidget {
//
//  final String text;
//  final timing;
//  final bool deviceId;
//  const Message({Key key, this.text,  this.timing, this.deviceId}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Container(
//      child: deviceId ?Row(
//        crossAxisAlignment: CrossAxisAlignment.end,
//        mainAxisAlignment:MainAxisAlignment.end,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Material(
//              color: Colors.orange,
//              borderRadius: BorderRadius.circular(10.0),
//              elevation: 6.0,
//              child: Row(
//                children: <Widget>[
//                  Container(
//                    width: MediaQuery.of(context).size.width - 170,
//                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//                    child: Text(
//                      text,style:
//                    TextStyle(color: Colors.black, fontSize: 20.0),
//                      maxLines: null,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top:35.0),
//            child: Text(
//                timing,style:
//            TextStyle(color: Colors.black, fontSize: 20.0)
//            ),
//          ),
//        ],
//      ) :
//      Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Material(
//              color: Colors.teal,
//              borderRadius: BorderRadius.circular(10.0),
//              child: Row(
//                children: <Widget>[
//                  Container(
//                   width: MediaQuery.of(context).size.width - 160,
//                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//                    child: Text(
//                      text,style:
//                    TextStyle(color: Colors.black, fontSize: 20.0),
//                      maxLines: null,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top:35.0),
//            child: Text(
//                '$timing',style:
//            TextStyle(color: Colors.black, fontSize: 20.0)
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
