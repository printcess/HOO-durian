import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 30,
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/record', (route) => false);
        },
        child: Row(
          children: [
            Image.asset(
              'assets/images/durianlogo.png', // Adjust the path to your logo image
              width: 50, // Adjust the width of the logo as needed
            ),
            Image.asset(
              'assets/images/tap2.png', // Adjust the path to your logo image
              width: 280,
            ),
          ],
        ),
      ),
      backgroundColor:
          const Color(0xFF2A492E), // Customize the background color
      centerTitle: true, // Center the title horizontally
      elevation: 0, // Remove the shadow below the app bar
      automaticallyImplyLeading: false, // Remove the back button
      // You can add more customizations here as needed
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      70); // Set the preferred height of the app bar to 50
}
