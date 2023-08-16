import 'package:get/get.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class UpdateTaskController extends GetxController{
  bool _updateTaskInProgress = false;
  bool get updateTaskInProgress => _updateTaskInProgress;
  Future<bool> updateTask(String title, String description, var onUpdate) async {

    _updateTaskInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      //"status": "Completed"
    };

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.createTaskUrl, requestBody);

    _updateTaskInProgress = false;
    update();

    if(response.isSuccess){
      return true;
    }else{
      return false;
    }

  }

}