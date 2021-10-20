import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject{
  // HiveField key 1 was used
  @HiveField(0)
  String name;

  Group({
    required this.name,
});

}