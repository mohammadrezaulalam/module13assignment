import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/cancelled_task_controller.dart';
import 'package:task_manager_project_getx/ui/state_managers/delete_task_controller.dart';
import '../../data/models/task_list_model.dart';
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
                          itemCount: cancelledTaskController.taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return GetBuilder<DeleteTaskController>(
                              builder: (deleteTaskController) {
                                return TaskListTile(
                                  chipBgColor: chipBgColorRed,
                                  taskStatus: 'Cancelled',
                                  data: cancelledTaskController.taskListModel.data![index],
                                  onDeleteTap: () {
                                    deleteTaskController.deleteTask(cancelledTaskController.taskListModel.data![index].sId!).then((result) => {
                                      if(result == true){
                                        Get.snackbar(
                                          'Success',
                                          'Task Deleted Successfully',
                                          colorText: Colors.white,
                                        ),
                                        cancelledTaskController.taskListModel.data!.removeWhere((element) => element.sId == cancelledTaskController.taskListModel.data![index].sId!),
                                        setState(() {

                                        })
                                      }else{
                                        Get.snackbar(
                                          'Failed',
                                          'Task Deletion Unsuccessful',
                                          colorText: Colors.red,
                                        )
                                      }
                                    });
                                  },
                                  onEditTap: () {
                                    showStatusUpdateBottomSheet(cancelledTaskController.taskListModel.data![index]);
                                  },
                                );
                              }
                            );
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
