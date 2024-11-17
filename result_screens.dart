import 'dart:convert';
import 'dart:io';

import 'package:doo/mat/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key, required this.audioPath}) : super(key: key);

  final String audioPath;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int type = 0;
  late Future<String> futureData;
  String audioPath = '';

  Widget getResults() {
    print('type $type');
    switch (type) {
      case 2:
        return type2();
      case 1:
        return type1();
      case 0:
        return type0();
      default:
        return type1();
    }
  }

  Widget type2() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/images/durianlogo.png', width: 200),
      const SizedBox(
        height: 20,
      ),
      Image.asset('assets/images/result1.png', width: 200),
      const SizedBox(
        height: 20,
      ),
      Image.asset('assets/images/result1_2.PNG', width: 400),
    ]);
  }

  Widget type1() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/images/raw.png', width: 200),
      const SizedBox(
        height: 20,
      ),
      Image.asset('assets/images/result2.png', width: 200),
      const SizedBox(
        height: 20,
      ),
      Image.asset('assets/images/result2_2.PNG', width: 400),
    ]);
  }

  Widget type0() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset('assets/images/crispysoft.png', width: 200),
      const SizedBox(
        height: 20,
      ),
      Image.asset('assets/images/result3.png', width: 200),
      const SizedBox(
        height: 20,
      ),
      Image.asset('assets/images/result3_2.PNG', width: 400),
    ]);
  }

  Widget showResult() {
    return Center(
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/record', (route) => false);
            },
            child: getResults()));
  }

  doUpload(audioPath) async{
      //var mp3 = File(audioPath);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://vision.eng.nu.ac.th/bettafishdetect/doo/predict"),
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        await http.MultipartFile.fromPath('audio', audioPath)
      );
      request.headers.addAll(headers);
      print("request: " + request.toString());
      request.send().then((value) => {
        value.stream.bytesToString().then((value) => {
          print(value),
          // var parsedJson = jsonDecode(value),
          // print(parsedJson['class']),
          // type = parsedJson['class'],
          // setState(() {})
        })
      
      });
    }


  Future<String> fetchData() async {
    // final response = await http.post(
    //     Uri.parse('https://vision.eng.nu.ac.th/bettafishdetect/doo/predict'));
    // if (response.statusCode == 200) {
    //   final parsedJson = jsonDecode(response.body);
    //   print(parsedJson['class']);
    //   type = parsedJson['class'];
    //   return response.body;
    // } else {
    //   throw Exception('Failed to load data');
    // }
    try{
      final url =
          Uri.parse('https://vision.eng.nu.ac.th/bettafishdetect/doo/predict'); // Replace with your server's upload URL

      final file = File(widget.audioPath);
      print('audio path ${widget.audioPath}');
      if (!file.existsSync()) {
        print(
            "UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
        return 'none';
      }
      print(
          "UPLOADING FILE ++++++++++++++++$audioPath+++++++++++++++++++++++++++++++++");
      final request = http.MultipartRequest('POST', url)
        ..files.add(
          http.MultipartFile(
            'audio',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: 'audio.mp3', // You may need to adjust the file extension
          ),
        );

      final response = await http.Response.fromStream(await request.send());
      print('response: ${response.body}');
      if (response.statusCode == 200) {
        // convert string to int 
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['class']);
        type = parsedJson['class'];
        setState(() {});
      }
    }
    catch(e){
      print(e);
    }
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: const CustomAppBar(title: "Durian"),
      // backgroundColor: const Color.fromRGBO(204, 255, 153, 1),
      body: FutureBuilder<String>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return showResult();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
