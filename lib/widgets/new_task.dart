import 'package:flutter/material.dart';
import 'package:login_app/model/task.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key, required this.onAddTask});
  final void Function(Task task) onAddTask;
  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.personal;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _submitTaskData() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text(
              'Merci de saisir le titre de la tâche à ajouter dans la liste'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddTask(Task(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!, // Utilisez ! pour accéder à la valeur non nulle
        category: _selectedCategory));
  }

  void _selectDate() async {
    DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          //la date minimale sélectionnable, définie sur le 1er janvier 2000.
          firstDate: DateTime(2000),
          //la date maximale sélectionnable, définie sur le 31 décembre 2100.
          lastDate: DateTime(2101), //valeur de date initiale par defaut
        )) ??
        DateTime.now();

    if (pickedDate != null && pickedDate != _selectedDate) { // signifie qu'une nouvelle date a été sélectionnée.
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 200,
            decoration: const InputDecoration(
              label: Text('Task title'),
            ),
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 200,
            decoration: const InputDecoration(
              label: Text('Task description'),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Text(
                  "Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}"), // Affiche la date sélectionnée
              TextButton(
                onPressed: _selectDate,
                child: Text('Select Date'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              DropdownButton<Category>(
                value: _selectedCategory,
                style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                items: Category.values
                    .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(width: 25),
              ElevatedButton(
                onPressed: _submitTaskData,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
