import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_with_db/domain/data_provider/box_manager.dart';
import 'package:todo_with_db/domain/entity/group.dart';
import 'package:todo_with_db/ui/navigation/main_navigation.dart';
import 'package:todo_with_db/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable? _listenableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }
  void showForm(BuildContext context) =>
      Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null){
    final configuration = TaskWidgetConfiguration(group.key as int, group.name);
    unawaited(
      Navigator.of(context).pushNamed(MainNavigationRouteNames.tasks, arguments: configuration),
    );
    }
  }

  Future<void> deleteGroup(int index) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(index) as int;
    final boxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(boxName);
    await box.deleteAt(index);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await BoxManager.instance.closeBox((await _box));
    _listenableBox?.removeListener(_readGroupsFromHive);
  }

}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static GroupsWidgetModelProvider of(BuildContext context) {
    final GroupsWidgetModelProvider? result =
        context.dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
    assert(result != null, 'No GroupsWidgetModelProvider found in context');
    return result!;
  }
}
