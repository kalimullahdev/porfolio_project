import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key, required this.startSequence});

  final Future<void> Function() startSequence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: key,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: InkWell(
            onTap: startSequence,
            child: Container(
              height: 100,
              width: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: BoxBorder.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Text(
                  "Let's get started",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
