import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_sqllite/core/database_service.dart';
import 'package:todo_bloc_sqllite/features/splashscreen/splash_page.dart';
import 'package:todo_bloc_sqllite/features/todo_display/bloc/todo_bloc.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/repository/todo_repository_imp.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final ITodoRespository todoRepo =
      ITodoRespository(dbService: DatabaseService.instance);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc(respository: todoRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Scaffold(
          body: SpalshPage(),
        ),
      ),
    );
  }
}
