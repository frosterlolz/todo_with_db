import 'package:flutter/material.dart';
import 'package:todo_with_db/domain/data_provider/box_manager.dart';
import 'package:todo_with_db/domain/entity/task.dart';
import 'package:todo_with_db/ui/widgets/tasks_form/task_form_widget.dart';

class TaskFormWidgetModel extends ChangeNotifier {
  int? taskKey;
  TaskWidgetFormConfiguration configuration;
  var _taskText = '';
  bool get isValid => _taskText.trim().isNotEmpty;

  set taskText(String value){
    final isTaskTextEmpty = _taskText.trim().isEmpty;
    _taskText = value;
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  TaskFormWidgetModel({required this.configuration, this.taskKey});

  void saveTask(BuildContext context) async {
    final taskText = _taskText.trim();
    if (taskText.isEmpty) return;

    final task = Task(text: taskText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(configuration.groupKey);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }

  void editTask(BuildContext context) async {
    final taskText = _taskText.trim();
    if (taskText.isEmpty) return;

    final task = Task(text: taskText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(configuration.groupKey);
    await box.put(configuration.taskKey, task);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static TaskFormWidgetModelProvider of(BuildContext context) {
    final TaskFormWidgetModelProvider? result = context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
    assert(result != null, 'No TaskFormWidgetModelProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(oldWidget) => false;
}