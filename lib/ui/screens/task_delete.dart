import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskDelete {
// String? taskId;
//
// TaskDelete(this.taskId);

Future<bool> deleteTask(String taskId) async {
  final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));
  if(response.isSuccess){
    //newTaskController.taskListModel.data!.removeWhere((element) => element.sId == taskId);
    // if(mounted){
    //   setState(() {});
    // }
    return true;
  }else{
    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(
    //         'Failed to delete Task Data',
    //         style: snackBarText(chipBgColorRed),
    //       )));
    // }
    return false;
  }
}

}
