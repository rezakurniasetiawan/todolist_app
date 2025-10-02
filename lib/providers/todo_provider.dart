import 'package:flutter/material.dart';
import '../data/models/todo_model.dart';
import '../domain/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepository _repository = TodoRepository();

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await _repository.getTodos();
    _sortTodos();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;
    await _repository.addTodo(Todo(title: title));
    await loadTodos();
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    final updated = todo.copyWith(isDone: !todo.isDone);
    await _repository.updateTodo(updated);
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _repository.deleteTodo(id);
    await loadTodos();
  }

  void _sortTodos() {
    _todos.sort((a, b) {
      if (a.isDone == b.isDone) {
        return a.id!.compareTo(b.id!);
      }
      return a.isDone ? 1 : -1;
    });
  }
}
