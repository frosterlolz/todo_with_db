import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_with_db/ui/widgets/tasks/tasks_widget_model.dart';

class TaskWidgetConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TasksWidget({Key? key, required this.configuration}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
        model: _model, child: const TasksWidgetBody());
  }

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context).model;
    final title = model.configuration.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TasksListWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            TasksWidgetModelProvider.of(context).model.showForm(context),
      ),
    );
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int tasksCount =
        TasksWidgetModelProvider.of(context).model.tasks.isEmpty
            ? 0
            : TasksWidgetModelProvider.of(context).model.tasks.length;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _TasksListRowWidget(
        indexInList: index,
      ),
      itemCount: tasksCount,
    );
  }
}

class _TasksListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TasksListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context).model;
    final task = model.tasks[indexInList];
    final icon = task.isDone ? Icons.done : Icons.edit;
    final textStyle = task.isDone ? TextDecoration.lineThrough : null;
    final secAction = task.isDone
        ? IconSlideAction(
            caption: 'NotDone',
            color: Colors.blue,
            icon: Icons.refresh,
            onTap: () => model.doneToggle(indexInList),
          )
        : IconSlideAction(
            caption: 'Done',
            color: Colors.green,
            icon: Icons.done,
            onTap: () => model.doneToggle(indexInList),
          );

    void _showSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
    }

    return Card(
      child: Slidable(
        key: UniqueKey(),
        dismissal: SlidableDismissal(
          child: const SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            actionType == SlideActionType.primary
            ? model.doneToggle(indexInList)
            : model.deleteTask(indexInList);
            _showSnackBar(
                context,
                actionType == SlideActionType.primary
                    ? 'Task is${task.isDone ? ' not ' : ''}done!'
                    : 'Task was deleted!');
          },
        ),
        actionPane: const SlidableBehindActionPane(),
        child: ColoredBox(
          color: Colors.white,
          child: ListTile(
            title: Text(
              task.text,
              style: TextStyle(decoration: textStyle),
            ),
            trailing: Icon(
              icon,
              color: task.isDone ? Colors.green : null,
            ),
            onTap: () => model.editForm(context, indexInList),
          ),
        ),
        actions: [
          secAction,
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => model.deleteTask(indexInList),
          ),
        ],
      ),
    );
  }
}
