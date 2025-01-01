import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_empty_1/onboarding/onboarding_items.dart';
import "package:test_empty_1/home/home.dart";

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  final emailController = TextEditingController();
  bool isLastPage = false;
  bool isValidEmail = false;

  bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmoothPageIndicator(
            controller: pageController, 
            count: controller.items.length,
            effect: const WormEffect(
              activeDotColor: Colors.purple,
            ),
          ),
          if (!isLastPage)
            TextButton(
              onPressed: () => pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
              child: const Text("Next")
            )
          else
            TextButton(
              onPressed: isValidEmail 
                ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Home()))
                : null,
              child: const Text("Get started")
            )
          ],
        ),
      ),
      body: PageView.builder(
        onPageChanged: (index) => setState(() {isLastPage = controller.items.length-1 == index;}),
        itemCount: controller.items.length,
        controller: pageController,
        itemBuilder: (context, index){
          if (index == controller.items.length - 1) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enter your email to get started",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        isValidEmail = validateEmail(value);
                      });
                    },
                  ),
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(controller.items[index].imageUrl),
              const SizedBox(height: 15,),
              Text(controller.items[index].title, style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
              const SizedBox(height: 15,),
              Text(controller.items[index].description),
             ],
          );
      }),
    );
  }
}