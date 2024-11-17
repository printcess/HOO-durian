import 'dart:async';
import 'dart:math';
import 'package:doo/mat/CustomAppBar.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:doo/screens/result_screens.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = "";
  Image imageCount =
      Image.asset('assets/images/durianlogo.png', width: 200, height: 200);

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    audioRecord.dispose();
    audioPlayer.dispose();
  }

  bool playing = false;

  // trigger the stop recording after 3 seconds

  Future<void> startRecording() async {
    // sleep 1 sec
    setState(() {
      imageCount =
          Image.asset('assets/images/num3.png', width: 200, height: 200);
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      imageCount =
          Image.asset('assets/images/num2.png', width: 200, height: 200);
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      imageCount =
          Image.asset('assets/images/num1.png', width: 200, height: 200);
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      imageCount = Image.asset('assets/images/0.png', width: 200, height: 200);
    });

    try {
      print("START RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
      if (await audioRecord.hasPermission()) {
        const encoder = AudioEncoder.wav;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }

        final path = await _getPath();

        const config = RecordConfig(encoder: encoder, numChannels: 1);
        await audioRecord.start(config, path: path);
        setState(() {
          isRecording = true;

          //show snackbar
          const snackBar = SnackBar(
            content: Text('Recording started'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        Timer(const Duration(seconds: 1), () {
          stopRecording();
        });
      }
    } catch (e, stackTrace) {
      print(
          "START RECODING+++++++++++++++++++++${e}++++++++++${stackTrace}+++++++++++++++++");
    }
  }

  Future<String> _getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await audioRecord.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await audioRecord.isEncoderSupported(e)) {
          debugPrint('- ${encoder.name}');
        }
      }
    }

    return isSupported;
  }

  Future<void> stopRecording() async {
    try {
      print("STOP RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
      String? path = await audioRecord.stop();
      setState(() {
        recoding_now = false;
        isRecording = false;
        audioPath = path!;

        imageCount = Image.asset('assets/images/wave.PNG', width: 300);
      });
    } catch (e) {
      print(
          "STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
    }
  }

  Future<void> playRecording() async {
    try {
      playing = true;
      setState(() {});

      print("AUDIO PLAYING+++++++++++++++++++++++++++++++++++++++++++++++++");
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
      // Add an event listener to be notified when the audio playback completes
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.completed) {
          playing = false;

          print(
              "AUDIO PLAYING ENDED+++++++++++++++++++++++++++++++++++++++++++++++++");
          setState(() {});
        }
      });
    } catch (e) {
      print(
          "AUDIO PLAYING++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
    }
  }

  Future<void> pauseRecording() async {
    try {
      playing = false;

      print("AUDIO PAUSED+++++++++++++++++++++++++++++++++++++++++++++++++");

      await audioPlayer.pause();
      setState(() {});
      //print('Hive Playing Recording ${voiceRecordingsBox.values.cast<String>().toList().toString()}');
    } catch (e) {
      print(
          "AUDIO PAUSED++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
    }
  }

  Future<void> uploadAndDeleteRecording() async {
    // get random number 1-3
    int type = Random().nextInt(3) + 1;
    print('audioPath: $audioPath');
    // goto result screen
    // Navigator.pushNamed(context, '/result', arguments: {'type': type,'audioPath':audioPath});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(audioPath: audioPath),
      ),
    );

    // try {
    //   final url =
    //       Uri.parse('YOUR_UPLOAD_URL'); // Replace with your server's upload URL

    //   final file = File(audioPath);
    //   if (!file.existsSync()) {
    //     print(
    //         "UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
    //     return;
    //   }
    //   print(
    //       "UPLOADING FILE ++++++++++++++++$audioPath+++++++++++++++++++++++++++++++++");
    //   final request = http.MultipartRequest('POST', url)
    //     ..files.add(
    //       http.MultipartFile(
    //         'audio',
    //         file.readAsBytes().asStream(),
    //         file.lengthSync(),
    //         filename: 'audio.mp3', // You may need to adjust the file extension
    //       ),
    //     );

    //   final response = await http.Response.fromStream(await request.send());

    //   if (response.statusCode == 200) {
    //     // Upload successful, you can delete the recording if needed
    //     // Show a snackbar or any other UI feedback for a successful upload
    //     const snackBar = SnackBar(
    //       content: Text('Audio uploaded.'),
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);

    //     // Refresh the UI
    //     setState(() {
    //       audioPath = "";
    //     });
    //   } else {
    //     // Handle the error or show an error message
    //     print('Failed to upload audio. Status code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Error uploading audio: $e');
    // }
  }

  Future<void> deleteRecording() async {
    if (audioPath.isNotEmpty) {
      try {
        imageCount = Image.asset('assets/images/durianlogo.png',
            width: 200, height: 200);
        recoding_now = true;
        File file = File(audioPath);
        if (file.existsSync()) {
          file.deleteSync();
          setState(() {
            //show snackbar
            const snackBar = SnackBar(
              content: Text('Recoding deleted'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          print(
              "FILE DELETED+++++++++++++++++++++++++++++++++++++++++++++++++");
        }
      } catch (e) {
        print(
            "FILE NOT DELETED++++++++++++++++${e}+++++++++++++++++++++++++++++++++");
      }

      setState(() {
        audioPath = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments['reset'] == true) {
      recoding_now = true;
      imageCount =
          Image.asset('assets/images/durianlogo.png', width: 200, height: 200);
    }
    return Scaffold(
        appBar: const CustomAppBar(title: "Durian"),
        // backgroundColor: const Color.fromRGBO(204, 255, 153, 1),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageCount,
            recoding_now
                ? IconButton(
                    icon: !isRecording
                        ? Image.asset('assets/images/start.png', width: 150)
                        // ? const Icon(
                        //     Icons.mic_none,
                        //     color: Colors.red,
                        //     size: 50,
                        //   )
                        : const Icon(Icons.fiber_manual_record,
                            color: Colors.red, size: 50),
                    onPressed: isRecording ? stopRecording : startRecording,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: !playing
                            ? const Icon(Icons.play_circle,
                                color: Colors.green, size: 50)
                            : const Icon(Icons.pause_circle,
                                color: Colors.green, size: 50),
                        onPressed: !playing ? playRecording : pauseRecording,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 50),
                        onPressed: deleteRecording,
                      ),
                      IconButton(
                        icon: const Icon(Icons.trending_up,
                            color: Colors.green, size: 50),
                        onPressed: uploadAndDeleteRecording,
                      ),
                    ],
                  ),
          ],
        )));
  }

  bool recoding_now = true;
}
