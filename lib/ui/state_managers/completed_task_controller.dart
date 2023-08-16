import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CompletedTaskController extends GetxController{
  bool _getCompletedTaskInProgress = false;
  bool get completedTaskInProgress => _getCompletedTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.completedTasksUrl);

    _getCompletedTaskInProgress = false;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
      update();
      return true;
    } else {
      update();
      return false;
    }
  }

}