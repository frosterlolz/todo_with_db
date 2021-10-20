import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_with_db/domain/data_provider/box_manager.dart';
import 'package:todo_with_db/domain/entity/task.dart';
import 'package:todo_with_db/ui/navigation/main_navigation.dart';
import 'package:todo_with_db/ui/widgets/tasks/tasks_widget.dart';
import 'package:todo_with_db/ui/widgets/tasks_form/task_form_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  final TaskWidgetConfiguration configuration;
  ValueListenable? _listenableBox;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }

  Future<void> showForm(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.tasksForm,
          arguments:
              TaskWidgetFormConfiguration(groupKey: configuration.groupKey));

  // TODO: передать task key...
  Future<void> editForm(BuildContext context, index) async {
    final int _groupKey = configuration.groupKey;
    final task = (await _box).getAt(index);
    if (task != null) {
      final configuration = TaskWidgetFormConfiguration(
          taskKey: task.key as int, title: task.text, groupKey: _groupKey);
      Navigator.of(context).pushNamed(MainNavigationRouteNames.tasksForm,
          arguments: configuration);
    }
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);
    await _readTasksFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  Future<void> deleteTask(int index) async {
    await (await _box).deleteAt(index);
  }

  Future<void> doneToggle(int index) async {
    final task = (await _box).getAt(index);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await BoxManager.instance.closeBox((await _box));
    _listenableBox?.removeListener(_readTasksFromHive);
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static TasksWidgetModelProvider of(BuildContext context) {
    final TasksWidgetModelProvider? result =
        context.dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
    return result!;
  }
}
