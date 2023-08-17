import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_bottom_sheet.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/delete_task_controller.dart';
import 'package:task_manager_project_getx/ui/state_managers/in_progress_task_controller.dart';
import '../../data/models/task_list_model.dart';
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
                            return GetBuilder<DeleteTaskController>(
                              builder: (deleteTaskController) {
                                return TaskListTile(
                                  chipBgColor: chipBgColorPurple,
                                  taskStatus: 'Progress',
                                  data: inProgressTaskController.taskListModel.data![index],
                                  onDeleteTap: () {
                                    deleteTaskController.deleteTask(inProgressTaskController.taskListModel.data![index].sId!).then((result) => {
                                      if(result == true){
                                        Get.snackbar(
                                          'Success',
                                          'Task Deleted Successfully',
                                          colorText: Colors.white,
                                        ),
                                        inProgressTaskController.taskListModel.data!.removeWhere((element) => element.sId == inProgressTaskController.taskListModel.data![index].sId!),
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
                                    showStatusUpdateBottomSheet(inProgressTaskController.taskListModel.data![index]);
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
