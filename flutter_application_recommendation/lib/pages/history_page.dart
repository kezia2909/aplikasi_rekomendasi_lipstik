import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/services/database_service.dart';

class HistoryPage extends StatefulWidget {
  final User firebaseUser;

  const HistoryPage({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late User user = widget.firebaseUser;

  List<String> history = [
    "Alfa",
    "Bravo",
    "Charlie",
    "Delta",
    "Echo",
    "Foxtrot",
    "Golf",
    "Hotel",
    "India",
    "Juliett",
    "Kilo",
    "Lima",
    "Mike",
    "November",
    "Oscar",
    "Papa",
    "Quebec",
    "Romeo",
    "Sierra",
    "Tango",
    "Uniform",
    "Victor",
    "Whiskey",
    "X-ray",
    "Yankee",
    "Zulu"
  ];

  final _searchHistoryController = TextEditingController();
  Stream<QuerySnapshot<Object?>> onSearch() {
    setState(() {});
    return DatabaseService.getHistoryRekomendasi(_searchHistoryController.text,
        userId: user.uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    _searchHistoryController.addListener(onSearch);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchHistoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text("Reset History"),
                    onPressed: () {},
                  ),
                ],
              ),
              TextField(
                controller: _searchHistoryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'cari history',
                ),
                onChanged: (String value) {
                  onSearch();
                  // setState(() {});
                },
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: history.length,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         color: (index % 2 == 0) ? Colors.grey : Colors.white,
              //         padding: EdgeInsets.all(10.0),
              //         child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(history[index]),
              //               Row(
              //                 children: [
              //                   Icon(Icons.info_rounded),
              //                   Icon(Icons.delete)
              //                 ],
              //               ),
              //             ]),
              //       );
              //     },
              //   ),
              // ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: onSearch(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Data Error");
                      } else if (snapshot.hasData || snapshot.data != null) {
                        if (snapshot.data!.size == 0) {
                          return Text("Data Not Found");
                        } else {
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              DocumentSnapshot historyData =
                                  snapshot.data!.docs[index];
                              String name = historyData['nameHistory'];
                              return Container(
                                color: (index % 2 == 0)
                                    ? Colors.grey
                                    : Colors.white,
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(name),
                                      Row(
                                        children: [
                                          Icon(Icons.info_rounded),
                                          Icon(Icons.delete)
                                        ],
                                      ),
                                    ]),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.0),
                            itemCount: snapshot.data!.docs.length,
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.pinkAccent,
                          ),
                        ),
                      );
                    }
                    // return ListView.builder(
                    //   itemCount: history.length,
                    //   itemBuilder: (context, index) {
                    //     return Container(
                    //       color:
                    //           (index % 2 == 0) ? Colors.grey : Colors.white,
                    //       padding: EdgeInsets.all(10.0),
                    //       child: Row(
                    //           mainAxisAlignment:
                    //               MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(history[index]),
                    //             Row(
                    //               children: [
                    //                 Icon(Icons.info_rounded),
                    //                 Icon(Icons.delete)
                    //               ],
                    //             ),
                    //           ]),
                    //     );
                    //   },
                    // );
                    ),
              )
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
