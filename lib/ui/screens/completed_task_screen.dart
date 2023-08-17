import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/completed_task_controller.dart';
import 'package:task_manager_project_getx/ui/state_managers/delete_task_controller.dart';
import '../../data/models/task_list_model.dart';
import '../style/style.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController completedTaskController = Get.put(CompletedTaskController());

  @override
  void initState() {
    super.initState();
    //After Widget Binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completedTaskController.getCompletedTasks();
    });
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
                            return GetBuilder<DeleteTaskController>(
                              builder: (deleteTaskController) {
                                return TaskListTile(
                                  chipBgColor: chipBgColorGreen,
                                  taskStatus: 'Completed',
                                  data: completedTaskController.taskListModel.data![index],
                                  onDeleteTap: () {
                                    deleteTaskController.deleteTask(completedTaskController.taskListModel.data![index].sId!).then((result) => {
                                      if(result == true){
                                        Get.snackbar(
                                          'Success',
                                          'Task Deleted Successfully',
                                          colorText: Colors.white,
                                        ),
                                        completedTaskController.taskListModel.data!.removeWhere((element) => element.sId == completedTaskController.taskListModel.data![index].sId!),
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
                                    showStatusUpdateBottomSheet(completedTaskController.taskListModel.data![index]);
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
