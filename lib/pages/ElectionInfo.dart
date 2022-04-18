import 'package:election/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

class ElectionIfno extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const ElectionIfno(
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  State<ElectionIfno> createState() => _ElectionIfnoState();
}

class _ElectionIfnoState extends State<ElectionIfno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.electionName.toUpperCase()),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<Object>(
                        future: getCandinateNum(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text("Total Candinates")
                  ],
                ),
                Column(
                  children: const [
                    Text(
                      "0",
                      style: TextStyle(
                         fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text("Total Votes")
                  ],
                )
              ],
            )
          ],
        ),
      ).p(12),
    );
  }
}
