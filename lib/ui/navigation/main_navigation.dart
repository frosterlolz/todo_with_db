import 'package:flutter/material.dart';
import 'package:todo_with_db/ui/widgets/groups/group_widget.dart';
import 'package:todo_with_db/ui/widgets/groups_form/group_form_widget.dart';
import 'package:todo_with_db/ui/widgets/tasks/tasks_widget.dart';
import 'package:todo_with_db/ui/widgets/tasks_form/task_form_widget.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  static const groupsForm = '/add_group';
  static const tasks = '/tasks';
  static const tasksForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;
  final routes = {
    MainNavigationRouteNames.groups: (context) => const GroupsScreen(),
    MainNavigationRouteNames.groupsForm: (context) => const AddGroup(),
    // MainNavigationRouteNames.tasks: (context) => const TasksWidget(groupKey: ,),
    // MainNavigationRouteNames.tasksForm: (context) => const TaskFormWidget(groupKey: ,),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final configuration = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
          builder: (context) => TasksWidget(configuration: configuration),
        );
      case MainNavigationRouteNames.tasksForm:
        final configuration = settings.arguments as TaskWidgetFormConfiguration;
        return MaterialPageRoute(
          //TODO: Continue doing editable screen for task
          builder: (context) => TaskFormWidget(configuration: configuration),
        );
      default:
        return MaterialPageRoute(builder: (context) => const FlutterLogo());
    }
  }
}
