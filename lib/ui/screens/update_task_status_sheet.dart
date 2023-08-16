import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/state_managers/update_task_status_controller.dart';
import '../../data/models/task_list_model.dart';
import '../style/style.dart';


class UpdateTaskStatusSheet extends StatefulWidget {

  final TaskData task;
  final VoidCallback onUpdate;
  const UpdateTaskStatusSheet({super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateTaskStatusSheet> createState() => _UpdateTaskStatusSheetState();
}

class _UpdateTaskStatusSheetState extends State<UpdateTaskStatusSheet> {
  List<String> taskStatusList = ['new', 'progress', 'cancelled', 'completed'];
  late String _selectedTask;

  final UpdateTaskStatusController updateTaskStatusController = Get.put(UpdateTaskStatusController());

  @override
  void initState() {
    super.initState();
    _selectedTask = widget.task.status!;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Update Status', style: appHeadingText2(colorBlack),),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: taskStatusList.length,
                itemBuilder: (context, index){
                  return ListTile(
                    onTap: (){
                      _selectedTask = taskStatusList[index].captz();
                      setState(() {});
                    },
                    title: Text(taskStatusList[index].captz()),
                    trailing: _selectedTask == taskStatusList[index].captz()
                        ? const Icon(Icons.check_circle_outline_outlined)
                        : null,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Visibility(
                visible: updateTaskStatusController.updateTaskStatusInProgress == false,
                replacement: const Center(child: CircularProgressIndicator(),),
                child: ElevatedButton(
                  onPressed: (){
                    updateTaskStatusController.updateTaskStatus(widget.task.sId.toString(), _selectedTask, widget.onUpdate).then((result) => {
                      if(result == true){
                        Get.back(),
                        Get.snackbar('Success', 'Status Update Successful')
                      }else{
                        Get.snackbar('Failed', 'Status Update Failed')
                      }
                    });
                    //updateTaskStatus(widget.task.sId!, _selectedTask);
                  },
                  style: appButtonStyle(),
                  child: Text('Update', style: appHeadingText5(colorWhite),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _taskListModel {
// }

extension MyExtension on String{
  String captz(){
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
