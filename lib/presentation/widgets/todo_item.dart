import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/data/models/todo_model.dart';
import '../../providers/todo_provider.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => provider.deleteTodo(todo.id ?? 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: todo.isDone ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: ListTile(
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (_) => provider.toggleTodoStatus(todo),
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                color: todo.isDone ? Colors.grey : Colors.black87,
              ),
              child: Text(todo.title),
            ),
            trailing: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: todo.isDone
                  ? const Icon(Icons.check_circle, color: Colors.green, key: ValueKey("done"))
                  : const Icon(Icons.circle_outlined, color: Colors.grey, key: ValueKey("undone")),
            ),
          ),
        ),
      ),
    );
  }
}
