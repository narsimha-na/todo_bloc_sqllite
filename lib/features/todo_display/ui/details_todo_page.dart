import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc_sqllite/core/constants/constants.dart';
import 'package:todo_bloc_sqllite/core/widgets/custom_text.dart';
import 'package:todo_bloc_sqllite/features/todo_display/bloc/todo_bloc.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/models/todo.dart';

class DetailsTodoPage extends StatefulWidget {
  const DetailsTodoPage({super.key});

  @override
  State<DetailsTodoPage> createState() => _DetailsTodoPageState();
}

class _DetailsTodoPageState extends State<DetailsTodoPage> {
  final TextEditingController _text = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  bool toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<TodoBloc>().add(const FetchTodos());
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state is DisplaySpecificTodo) {
            Todo currentTodo = state.todo;
            return Column(
              children: [
                const CustomText(text: 'Title'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(controller: _text, enabled: false),
                const SizedBox(height: 10),
                const CustomText(text: 'Desc'),
                const SizedBox(height: 10),
                TextFormField(controller: _desc, enabled: false),
                const SizedBox(height: 10),
                const CustomText(text: 'Date Made'),
                const SizedBox(height: 10),
                CustomText(
                    text: DateFormat.yMMMEd().format(state.todo.createdTime)),
                const SizedBox(height: 10),
                CustomText(text: 'important / not important'.toUpperCase()),
                const SizedBox(height: 10),
                CustomText(
                    text: (state.todo.isImportant == true
                            ? 'important'
                            : 'not important')
                        .toUpperCase()),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Update Todo',
                              style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Title')),
                                Flexible(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      isDense: true,
                                    ),
                                    maxLines: 1,
                                    controller: _text,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Description')),
                                Flexible(
                                  child: TextFormField(
                                    controller: _desc,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text('Important / Not Important'),
                                    Switch(
                                      value: toggleSwitch,
                                      onChanged: (newVal) {
                                        setState(() {
                                          toggleSwitch = newVal;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                style: Constants.customButtonStyle,
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: Constants.customButtonStyle,
                                onPressed: () async {
                                  context.read<TodoBloc>().add(
                                        UpdateTodo(
                                          todo: Todo(
                                            id: currentTodo.id,
                                            createdTime: DateTime.now(),
                                            description: _desc.text,
                                            isImportant: toggleSwitch,
                                            number: currentTodo.number,
                                            title: _text.text,
                                          ),
                                        ),
                                      );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.black87,
                                    duration: Duration(seconds: 1),
                                    content: Text('Todo details updated'),
                                  ));
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  context
                                      .read<TodoBloc>()
                                      .add(const FetchTodos());
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text('EDIT'),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}
