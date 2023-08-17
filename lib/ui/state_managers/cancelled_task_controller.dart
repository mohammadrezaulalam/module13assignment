import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelledTaskController extends GetxController{
  bool _getCancelledTaskInProgress = false;
  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getCancelledTasks() async {
    _getCancelledTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.cancelledTasksUrl);
    _getCancelledTaskInProgress = false;
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