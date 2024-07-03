import 'package:todo_bloc_sqllite/features/todo_display/data/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<Todo> addTodo({required Todo todo});
  Future<int> upgradeTodo({required Todo todo});
  Future<void> deleteTodo({required int id});
  Future<Todo> getTodoById({required int id});
  Future<void> closeDBTodo();
}
