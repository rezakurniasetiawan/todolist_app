import '../data/db/todo_database.dart';
import '../data/models/todo_model.dart';

class TodoRepository {
  final _db = TodoDatabase.instance;

  Future<List<Todo>> getTodos() => _db.readAllTodos();
  Future<Todo> addTodo(Todo todo) => _db.create(todo);
  Future<int> updateTodo(Todo todo) => _db.update(todo);
  Future<int> deleteTodo(int id) => _db.delete(id);
}
