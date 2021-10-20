import 'package:flutter/material.dart';
import 'package:todo_with_db/ui/widgets/tasks_form/task_form_widget_model.dart';

class TaskWidgetFormConfiguration {
  final int groupKey;
  final int? taskKey;
  final String? title;

  TaskWidgetFormConfiguration(
      {this.taskKey, this.title, required this.groupKey});
}

class TaskFormWidget extends StatefulWidget {
  final TaskWidgetFormConfiguration configuration;
  const TaskFormWidget({Key? key, required this.configuration})
      : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TaskTextWidgetBody(),
    );
  }
}

class _TaskTextWidgetBody extends StatelessWidget {
  const _TaskTextWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.of(context).model;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            model.configuration.taskKey == null ? 'Add task' : 'Edit task'),
      ),
      body: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const _TaskTextWidget(),
      )),
      floatingActionButton: Visibility(
        visible: model.isValid,
        child: FloatingActionButton(
          child: const Icon(Icons.done),
          onPressed: () => model.configuration.taskKey == null
              ? model.saveTask(context)
              : model.editTask(context),
        ),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.of(context).model;
    return TextFormField(
      initialValue: model.configuration.title ?? '',
      maxLines: null,
      minLines: null,
      expands: true,
      onChanged: (value) => model.taskText = value,
      onEditingComplete: () => model.saveTask(context),
      textInputAction: TextInputAction.done,
      autofocus: true,
      decoration: const InputDecoration(
        disabledBorder: InputBorder.none,
        hintText: 'Task text',
      ),
    );
  }
}
