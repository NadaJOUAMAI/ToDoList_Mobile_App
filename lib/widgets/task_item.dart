import 'package:flutter/material.dart';
import 'package:login_app/model/task.dart';
import 'package:login_app/services/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {Key? key}) : super(key: key);
  final Task task;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    // Chargement de l'état du checkbox depuis SharedPreferences lors de l'initialisation
    loadTaskCompletionState();
  }

  // Méthode pour charger l'état du checkbox depuis SharedPreferences
  void loadTaskCompletionState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Charger la valeur du checkbox, par défaut false si elle n'existe pas
      isChecked = prefs.getBool(widget.task.title) ?? false;
    });
  }

  // Méthode pour enregistrer l'état du checkbox dans SharedPreferences
  void saveTaskCompletionState(bool completed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.task.title, completed);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      // Mettre à jour l'état du checkbox
                      isChecked = value ?? false;
                      // Enregistrez l'état dans SharedPreferences
                      saveTaskCompletionState(isChecked);
                      // Appeler la méthode de mise à jour du service Firestore
                      FirestoreService().updateTaskCompletion(
                        widget.task.title,
                        isChecked,
                      );
                    });
                  },
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        style: isChecked
                            ? const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                              )
                            : const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(widget.task.description),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(widget.task.date.toLocal())}',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text('Category : ${widget.task.category.name}',
                          textAlign: TextAlign.left),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Appeler la méthode de suppression du service Firestore
                    FirestoreService().deleteTaskByTitle(widget.task.title);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
