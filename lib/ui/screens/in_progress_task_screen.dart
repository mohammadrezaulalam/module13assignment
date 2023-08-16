import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_bottom_sheet.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/in_progress_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../style/style.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {

  final InProgressTaskController inProgressTaskController = Get.put(InProgressTaskController());


  @override
  void initState() {
    super.initState();
    //After Widget Binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inProgressTaskController.getInProgressTasks();
    });
  }

  // Future<void> getInProgressTasks() async {
  //   _getTaskInProgress = true;
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response =
  //       await NetworkCaller().getRequest(Urls.inProgressTasksUrl);
  //
  //   if (response.isSuccess) {
  //     _taskListModel = TaskListModel.fromJson(response.body!);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         'Failed to get In Progress Task Data',
  //         style: snackBarText(chipBgColorRed),
  //       )));
  //     }
  //   }
  //   _getTaskInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }
  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));
    if(response.isSuccess){
      inProgressTaskController.taskListModel.data!.removeWhere((element) => element.sId == taskId);
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

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskSheet(
          task: task,
          onUpdate: () {
            inProgressTaskController.getInProgressTasks();
          },
        );
      },
    );
  }

  void showStatusUpdateBottomSheet(TaskData task){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(task: task, onUpdate: (){
          inProgressTaskController.getInProgressTasks();
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
          GetBuilder<InProgressTaskController>(
            builder: (_) {
              return Expanded(
                child: inProgressTaskController.getTaskInProgress
                    ? const Center(child: CircularProgressIndicator(),)
                    : RefreshIndicator(
                  onRefresh: () async {
                    inProgressTaskController.getInProgressTasks();
                  },
                  child: inProgressTaskController.getTaskInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: inProgressTaskController.taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              chipBgColor: chipBgColorPurple,
                              taskStatus: 'Progress',
                              data: inProgressTaskController.taskListModel.data![index],
                              onDeleteTap: () {
                                deleteTask(inProgressTaskController.taskListModel.data![index].sId!);
                              },
                              onEditTap: () {
                                showStatusUpdateBottomSheet(inProgressTaskController.taskListModel.data![index]);
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
