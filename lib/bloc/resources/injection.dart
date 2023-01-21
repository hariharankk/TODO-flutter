import 'package:todolist/models/group.dart';
import 'package:get_it/get_it.dart';


final locator = GetIt.instance;

void initGetIt() {
  locator.allowReassignment=true;
  locator.registerLazySingleton<Group>(() => Group.blank(),instanceName: 'creategroup');
}