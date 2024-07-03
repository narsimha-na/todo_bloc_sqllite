import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/models/todo.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository respository;
  TodoBloc({required this.respository}) : super(TodoInitial()) {
    List<Todo> todos = [];
    on<AddTodo>(
      (event, emit) async {
        await respository.addTodo(
          todo: Todo(
            isImportant: event.isImportant,
            number: event.number,
            title: event.title,
            description: event.description,
            createdTime: event.createdTime,
          ),
        );
      },
    );
    on<UpdateTodo>(
      (event, emit) async {
        await respository.upgradeTodo(todo: event.todo);
      },
    );

    on<FetchTodos>(
      (event, emit) async {
        todos = await respository.getAllTodos();
        emit(DisplayTodos(todo: todos));
      },
    );

    on<FetchSpecificTodo>(
      (event, emit) async {
        Todo todo = await respository.getTodoById(id: event.id);
        emit(DisplaySpecificTodo(todo: todo));
      },
    );
    on<DeleteTodo>(
      (event, emit) async {
        await respository.deleteTodo(id: event.id);
        add(const FetchTodos());
      },
    );
  }
}
