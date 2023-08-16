import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class InProgressTaskController extends GetxController{
  bool _getTaskInProgress = false;
  bool get getTaskInProgress => _getTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get taskListModel => _taskListModel;
  Future<bool> getInProgressTasks() async {
    _getTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.inProgressTasksUrl);

    _getTaskInProgress = false;
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