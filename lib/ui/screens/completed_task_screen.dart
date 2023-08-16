import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/completed_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../style/style.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  // bool _getCompletedTaskInProgress = false;
  // TaskListModel _taskListModel = TaskListModel();
  final CompletedTaskController completedTaskController = Get.put(CompletedTaskController());

  @override
  void initState() {
    super.initState();
    //After Widget Binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completedTaskController.getCompletedTasks();
    });
  }

  // Future<void> getCompletedTasks() async {
  //   _getCompletedTaskInProgress = true;
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response = await NetworkCaller().getRequest(Urls.completedTasksUrl);
  //   if (response.isSuccess) {
  //     _taskListModel = TaskListModel.fromJson(response.body!);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         'Failed to get Completed Task Data',
  //         style: snackBarText(chipBgColorRed),
  //       )));
  //     }
  //   }
  //   _getCompletedTaskInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));
    if(response.isSuccess){
      completedTaskController.taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if(mounted){
        setState(() {});
      }
    }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Failed to delete Task Data',
              style: snackBarText(chipBgColorRed),
            )));
      }
    }
  }


  void showStatusUpdateBottomSheet(TaskData task){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(task: task, onUpdate: (){
          completedTaskController.getCompletedTasks();
        },);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UserProfileBanner(),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<CompletedTaskController>(
            builder: (_) {
              return Expanded(
                child: completedTaskController.completedTaskInProgress
                    ? const Center(child: CircularProgressIndicator(),)
                    : RefreshIndicator(
                  onRefresh: () async {
                    completedTaskController.getCompletedTasks();
                  },
                  child: completedTaskController.completedTaskInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: completedTaskController.taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              chipBgColor: chipBgColorGreen,
                              taskStatus: 'Completed',
                              data: completedTaskController.taskListModel.data![index],
                              onDeleteTap: () {
                                deleteTask(completedTaskController.taskListModel.data![index].sId!);
                              },
                              onEditTap: () {
                                showStatusUpdateBottomSheet(completedTaskController.taskListModel.data![index]);
                              },
                            );
                            //return SizedBox();
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

}
