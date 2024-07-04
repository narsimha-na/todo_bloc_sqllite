import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_sqllite/features/todo_display/bloc/todo_bloc.dart';
import 'package:todo_bloc_sqllite/features/todo_display/ui/add_todo_page.dart';
import 'package:todo_bloc_sqllite/features/todo_display/ui/details_todo_page.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TODO'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AddTodoPage()));
        },
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) {
            context.read<TodoBloc>().add(const FetchTodos());
          }
          if (state is DisplayTodos) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Add a Todo',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    state.todo.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.todo.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<TodoBloc>().add(
                                          FetchSpecificTodo(
                                              id: state.todo[index].id!));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) =>
                                              const DetailsTodoPage()),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 14),
                                      child: Card(
                                        elevation: 10,
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    state.todo[index].title
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 28,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<TodoBloc>()
                                                          .add(DeleteTodo(
                                                            id: state
                                                                .todo[index]
                                                                .id!,
                                                          ));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          duration: Duration(
                                                            seconds: 1,
                                                          ),
                                                          content: Text(
                                                              "deleted todo"),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 36,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                state.todo[index].description
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            );
          }
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
