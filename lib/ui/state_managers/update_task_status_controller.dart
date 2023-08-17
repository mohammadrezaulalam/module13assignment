import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class UpdateTaskStatusController extends GetxController{
  bool _updateTaskStatusInProgress = false;
  bool get updateTaskStatusInProgress => _updateTaskStatusInProgress;

  Future<bool> updateTaskStatus(String taskId, String newStatus, var onUpdate) async {
    _updateTaskStatusInProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.updateTaskStatusUrl(taskId, newStatus));

    _updateTaskStatusInProgress = false;
    if(response.isSuccess){
      onUpdate();
      return true;
    }else{
      return false;
    }
  }


}