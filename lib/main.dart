import 'package:flutter/material.dart';
import 'List Page/Lists.dart';
import 'List Page/Profile.dart';
import 'Sign in_out/SignIn.dart';
import 'Sign in_out/SignUp.dart';
import 'Task Page/Tasks.dart';

main() {
  runApp(const startUp());
}

class startUp extends StatefulWidget {
  const startUp({super.key});

  @override
  State<startUp> createState() => _startUpState();
}

class _startUpState extends State<startUp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/SignIn',
      routes: {
        '/SignIn': (context) => const SignIn(),
        '/SignUp': (context) => const SignUp(),
        '/Lists': (context) => const Lists(),
        '/Profile': (context) => const Profile(),
        '/Tasks': (context) => const Tasks(),
      },
    );
  }
}


