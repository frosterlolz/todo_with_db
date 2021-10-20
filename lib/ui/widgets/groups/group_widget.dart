import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_with_db/ui/widgets/groups/groups_model_widget.dart';

class GroupsScreen extends StatefulWidget {

  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) =>
      GroupsWidgetModelProvider(model: _model, child: const _GroupWidgetBody());

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class _GroupWidgetBody extends StatelessWidget {
  const _GroupWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Groups of tasks'),
        ),
        body: const _GroupListWidget(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () =>
              GroupsWidgetModelProvider.of(context).model.showForm(context),
        ),
      );
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int groupsCount =
        GroupsWidgetModelProvider.of(context).model.groups.isEmpty
            ? 0
            : GroupsWidgetModelProvider.of(context).model.groups.length;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _GroupListRowWidget(
        indexInList: index,
      ),
      itemCount: groupsCount,
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.of(context).model;
    final group = GroupsWidgetModelProvider.of(context).model.groups[indexInList];
    return Card(
        child: Slidable(
          actionPane: const SlidableBehindActionPane(),
          child: ColoredBox(
            color: Colors.white,
            child: ListTile(
              title: Text(group.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => model.showTasks(context, indexInList),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => GroupsWidgetModelProvider.of(context).model.deleteGroup(indexInList),
            ),
          ],
        ),
      );}
}
