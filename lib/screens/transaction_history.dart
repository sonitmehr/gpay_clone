import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart' as model;

import '../providers/user_providers.dart';
import '../resources/colors.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white, // transparent status bar
    // ));
    model.User user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection("transaction_history")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        focusNode: FocusNode(),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.arrow_back),
                            suffixIcon: PopupMenuButton<String>(
                              onSelected: (value) {},
                              itemBuilder: (BuildContext context) {
                                return {'Send Feedback'}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.docs[index].id ==
                              "ignore_this_collection") {
                            return const SizedBox.shrink();
                          }
                          return ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: hexToColor(
                                    snapshot.data!.docs[index]['hexColor']),
                                child: Text(snapshot.data!.docs[index]['name']
                                    .substring(0, 1)
                                    .toUpperCase()),
                              ),
                            ),
                            title: Text(snapshot.data!.docs[index]['name']),
                            subtitle: Text(snapshot.data!.docs[index]['time']),
                            trailing: Text(
                                "₹${snapshot.data!.docs[index]['amount']}"),
                          );
                        }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
