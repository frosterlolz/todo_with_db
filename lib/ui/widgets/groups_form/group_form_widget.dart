import 'package:flutter/material.dart';
import 'package:todo_with_db/ui/widgets/groups_form/group_form_widget_model.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) => GroupFormWidgetModelProvider(model: _model,
  child: const _GroupFormWidgetBody());
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Add groups'),
    ),
    body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _GroupNameWidget(),
        )),
  );
}




class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.of(context).model;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          onChanged: (value) => model.groupName = value,
          onEditingComplete: ()=> model.saveGroup(context),
          textInputAction: TextInputAction.done,
          autofocus: true,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Group title',
              errorText: model.errorText,
          ),
        ),
        ElevatedButton(onPressed: () => GroupFormWidgetModelProvider.of(context).model.saveGroup(context),
            child: const Text('Add')),
      ],
    );
  }
}
