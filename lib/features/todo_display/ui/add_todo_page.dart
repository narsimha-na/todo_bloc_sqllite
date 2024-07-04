import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_sqllite/core/widgets/custom_text.dart';
import 'package:todo_bloc_sqllite/features/todo_display/bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  bool toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            CustomText(text: 'Title'),
            TextFormField(controller: _title),
            CustomText(text: 'Description'),
            TextFormField(controller: _desc),
            CustomText(text: 'Important'),
            Switch(
              value: toggleSwitch,
              onChanged: (val) {
                setState(() {
                  toggleSwitch = !toggleSwitch;
                });
              },
            ),
            BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  if (_title.text.isNotEmpty && _desc.text.isNotEmpty) {
                    context.read<TodoBloc>().add(
                          AddTodo(
                            title: _title.text,
                            isImportant: toggleSwitch,
                            number: 0,
                            description: _desc.text,
                            createdTime: DateTime.now(),
                          ),
                        );
                    context.read<TodoBloc>().add(
                          const FetchTodos(),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('todo added successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Title & Desc feilds must not be blank'),
                    ));
                  }
                },
                child: const Text('ADD TODO'),
              );
            }),
          ],
        ),
      ),
    ));
  }
}
