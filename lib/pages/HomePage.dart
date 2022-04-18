import 'package:election/pages/ElectionInfo.dart';
import 'package:election/services/functions.dart';
import 'package:election/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import "package:velocity_x/velocity_x.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Start Election"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter Election Name',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                      if (controller.text.length > 1) {
                        await startElection(controller.text, ethClient!);
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ElectionIfno(
                                ethClient: ethClient!,
                                electionName: controller.text)));
                      }
                    },
                    child: Text("Start Election")))
          ],
        ),
      ).p(12),
    );
  }
}
