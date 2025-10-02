import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';
import '../widgets/todo_item.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TodoProvider>(context, listen: false).loadTodos());
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Row(
          children: const [
            Icon(Icons.edit_note, color: Colors.blueAccent, size: 28),
            SizedBox(width: 8),
            Text("Tambah Tugas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: _controller,
            autofocus: true,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "Masukkan nama tugas...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.clear();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final provider = Provider.of<TodoProvider>(context, listen: false);
              if (_controller.text.trim().isNotEmpty) {
                provider.addTodo(_controller.text.trim());
              }
              Navigator.pop(context);
              _controller.clear();
            },
            icon: const Icon(Icons.check, size: 18, color: Colors.white),
            label: const Text(
              "Simpan",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text("To-Do List", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo 👋", style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9))),
                const SizedBox(height: 4),
                const Text(
                  "Apa yang mau kamu kerjakan hari ini?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          // Hint Section
          if (provider.todos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Row(
                children: const [
                  Icon(Icons.swipe_left, size: 18, color: Colors.grey),
                  SizedBox(width: 6),
                  Text("Geser ke kiri untuk menghapus tugas", style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),

          // List Section
          Expanded(
            child: provider.todos.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada tugas.\nTekan tombol + untuk menambahkan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.todos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(todo: provider.todos[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
