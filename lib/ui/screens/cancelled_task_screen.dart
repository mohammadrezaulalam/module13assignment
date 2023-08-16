import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/cancelled_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../style/style.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  final CancelledTaskController cancelledTaskController = Get.put(CancelledTaskController());

  @override
  void initState() {
    super.initState();
    //After Widget Binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cancelledTaskController.getCancelledTasks();
    });
  }

  // Future<void> getCancelledTasks() async {
  //   _getCancelledTaskInProgress = true;
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response =
  //       await NetworkCaller().getRequest(Urls.cancelledTasksUrl);
  //
  //   if (response.isSuccess) {
  //     _taskListModel = TaskListModel.fromJson(response.body!);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         'Failed to get Cancelled Task Data',
  //         style: snackBarText(chipBgColorRed),
  //       )));
  //     }
  //   }
  //   _getCancelledTaskInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));
    if(response.isSuccess){
      cancelledTaskController.tasklistModel.data!.removeWhere((element) => element.sId == taskId);
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
          cancelledTaskController.getCancelledTasks();
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
          GetBuilder<CancelledTaskController>(
            builder: (_) {
              return Expanded(
                child: cancelledTaskController.getCancelledTaskInProgress ?
                const Center(child: CircularProgressIndicator(),)
                    :RefreshIndicator(
                  onRefresh: () async {
                    cancelledTaskController.getCancelledTasks();
                  },
                  child: cancelledTaskController.getCancelledTaskInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: cancelledTaskController.tasklistModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              chipBgColor: chipBgColorRed,
                              taskStatus: 'Cancelled',
                              data: cancelledTaskController.tasklistModel.data![index],
                              onDeleteTap: () {
                                deleteTask(cancelledTaskController.tasklistModel.data![index].sId!);
                              },
                              onEditTap: () {
                                showStatusUpdateBottomSheet(cancelledTaskController.tasklistModel.data![index]);
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
