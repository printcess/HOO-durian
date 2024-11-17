import 'package:doo/mat/CustomAppBar.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Durian"),
      // backgroundColor: const Color.fromRGBO(204, 255, 153, 1),
      body: Center(
          child: GestureDetector(
              onTap: () {
                //GoRouter.of(context).go('/record');
                Navigator.pushNamedAndRemoveUntil(context, '/record', (route) => false);
              },
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset('assets/images/how2use.png')))),
    );
  }
}
