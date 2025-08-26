import 'package:flutter/material.dart';
import 'package:no15/screens/home_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: // 背景圖片
                Image.asset(
                  'assets/login_background.png',
                  fit: BoxFit.cover,
                ),
            ),
            // LOGO
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 150,  // 讓 LOGO 水平居中，這裡 50 是 LOGO 的寬度的一半
              child: Image.asset(
                  'assets/icon.png',
                  width: 300,
              ),
            )
          ],
        )
      ),
    );
  }
}