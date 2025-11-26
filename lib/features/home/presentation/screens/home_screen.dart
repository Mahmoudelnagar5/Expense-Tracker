import 'package:flutter/material.dart';
import '../widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Center(child: Text("Home Screen")),
    );
  }
}
