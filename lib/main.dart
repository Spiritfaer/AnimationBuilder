import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class StateController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  int count = 0;
  bool isPlay = false;

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}

class MyHomePage extends StatelessWidget {
  late final AnimationController _controller;
  MyHomePage({Key? key}) : super(key: key) {
    Get.put<StateController>(StateController());
    _controller = Get.find<StateController>()._animationController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animation Testing")),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            print('_controller.value = ${_controller.value}');
            return Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Transform.rotate(
                  angle: _controller.value * -4 * pi,
                  child: child,
                ),
              ),
            );
          },
          child: const Text(
            "FUN!",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      floatingActionButton: GetBuilder<StateController>(
        builder: (c) => ElevatedButton(
          child:
              !c.isPlay ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
          onLongPress: () {
            _controller.reset();
          },
          onPressed: () {
            if (c.isPlay) {
              _controller.repeat();
            } else {
              _controller.stop(canceled: false);
            }
            c.isPlay = !c.isPlay;
            c.update();
          },
        ),
      ),
    );
  }
}
