import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/model/task.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');
  Future<void> addTask(Task task) {
    return FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskTitle': task.title.toString(),
        'taskDesc': task.description.toString(),
        'taskDate' : Timestamp.fromDate(task.date),
        'taskCategory': task.category.toString(),
      },
    );
  }

  Stream<QuerySnapshot> getTasks() {
    final taskStream = tasks.snapshots();
    return taskStream;
  }

  /*Future<void> deleteTaskById(String taskId) async {
  await tasks.doc(taskId).delete();*/

  Future<void> deleteTaskByTitle(String taskTitle) async {
    QuerySnapshot querySnapshot =
        await tasks.where('taskTitle', isEqualTo: taskTitle).get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }

  void updateTaskCompletion(String taskTitle, bool isChecked) async {
    // Récupérer les documents correspondant au titre de la tâche
    final querySnapshot =
        await tasks.where('taskTitle', isEqualTo: taskTitle).get();

    // Vérifier si des documents correspondants ont été trouvés
    if (querySnapshot.docs.isNotEmpty) {
      // Récupérer la référence du premier document trouvé
      final taskDoc = querySnapshot.docs.first.reference;

      try {
        // Tenter de mettre à jour le champ 'completed' du document
        await taskDoc.update({
          'completed': isChecked,
        });
      } catch (e) {
        // Gérer les erreurs lors de la mise à jour du document
        print('Error updating document: $e');
      }
    } else {
      // Si aucun document correspondant n'est trouvé, afficher un message
      print('No document found with title: $taskTitle');
    }
  }
}
