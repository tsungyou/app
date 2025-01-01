import 'package:flutter/material.dart';
import 'package:test_empty_1/onboarding/onboarding_items.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: controller.items.length,
        controller: pageController,
        itemBuilder: (context, index){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(controller.items[index].imageUrl),
              Text(controller.items[index].title),
              Text(controller.items[index].description),
             ],
          );
      }),
    );
  }
}