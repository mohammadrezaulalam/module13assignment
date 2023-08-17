import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class DeleteTaskController extends GetxController{
  TaskListModel _taskListModel = TaskListModel();
  Future<bool> deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));

    if(response.isSuccess){
      return true;
    }else{
      return false;
    }
  }
}