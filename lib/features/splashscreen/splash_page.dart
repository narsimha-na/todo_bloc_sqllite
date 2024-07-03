import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_bloc_sqllite/features/todo_display/ui/todo_page.dart';

class SpalshPage extends StatefulWidget {
  const SpalshPage({super.key});

  @override
  State<SpalshPage> createState() => _SpalshPageState();
}

class _SpalshPageState extends State<SpalshPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(
      seconds: 4,
    )).then(
      (value) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TodoPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: LottieBuilder.network(
            'https://assets5.lottiefiles.com/packages/lf20_p9e3k0ln.json',
            repeat: false,
            animate: true,
          ),
        ),
      ),
    );
  }
}
