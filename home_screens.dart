import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(204, 255, 153, 1),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              // GoRouter.of(context).go('/details');
              Navigator.pushNamedAndRemoveUntil(context, '/details',ModalRoute.withName('/details'));
            },
            child: const ShakeImage(
              imageAssetPath: 'assets/images/durianlogo.png',
              width: 200.0,
              height: 200.0,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Doo',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}

class ShakeImage extends StatefulWidget {
  final String imageAssetPath;
  final double width;
  final double height;

  const ShakeImage({
    required this.imageAssetPath,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  _ShakeImageState createState() => _ShakeImageState();
}

class _ShakeImageState extends State<ShakeImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // Automatically start the shake animation when the widget is initialized
    _startShakeAnimation();
    // Start a timer to navigate to the details screen after a delay
    // Timer(const Duration(seconds: 5), () {
    //   GoRouter.of(context).go('/details');
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startShakeAnimation() {
    _controller.repeat(
        reverse: true); // Repeat the shake animation continuously
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details screen when the image is tapped
        //GoRouter.of(context).go('/details');
        Navigator.pushNamedAndRemoveUntil(context, '/details',ModalRoute.withName('/details'));
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: (_controller.value * 0.1 * pi), // Adjust the shake amplitude
            child: child,
          );
        },
        child: Image(
          image: AssetImage(widget.imageAssetPath),
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }
}
