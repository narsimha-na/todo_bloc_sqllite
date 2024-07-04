import 'package:todo_bloc_sqllite/core/database_service.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/models/todo.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/repository/todo_repository.dart';

class ITodoRespository extends TodoRepository {
  DatabaseService dbService;

  ITodoRespository({required this.dbService});

  @override
  Future<void> addTodo({required Todo todo}) {
    DatabaseService.instance.create(todo);
    return DatabaseService.instance.readAllTodos();
  }

  @override
  Future<void> closeDBTodo() {
    return DatabaseService.instance.close();
  }

  @override
  Future<void> deleteTodo({required int id}) {
    return DatabaseService.instance.delete(id: id);
  }

  @override
  Future<List<Todo>> getAllTodos() {
    return DatabaseService.instance.readAllTodos();
  }

  @override
  Future<Todo> getTodoById({required int id}) {
    return DatabaseService.instance.readTodo(id: id);
  }

  @override
  Future<int> upgradeTodo({required Todo todo}) {
    return DatabaseService.instance.update(todo: todo);
  }
}
