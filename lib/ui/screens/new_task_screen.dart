import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager_project_getx/ui/state_managers/get_summary_controller.dart';
import 'package:task_manager_project_getx/ui/state_managers/new_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';
import '../style/style.dart';
import 'add_new_task_screen.dart';
import 'update_task_bottom_sheet.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GetSummaryController getSummaryController = Get.put(GetSummaryController());
  final NewTaskController newTaskController = Get.put(NewTaskController());


  @override
  void initState() {
    super.initState();
    //After Widget Binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSummaryController.getCountSummary();
      newTaskController.getNewTasks();
    });
  }

  // Future<void> getCountSummary() async {
  //   _getCountSummaryInProgress = true;
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response = await NetworkCaller().getRequest(Urls.taskStatusCountUrl);
  //
  //   if (response.isSuccess) {
  //     _summaryCountModel = SummaryCountModel.fromJson(response.body!);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         'Failed to get Summary Data',
  //         style: snackBarText(chipBgColorRed),
  //       )));
  //     }
  //   }
  //   _getCountSummaryInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // Future<void> getNewTasks() async {
  //   _getNewTaskInProgress = true;
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response = await NetworkCaller().getRequest(Urls.newTasksUrl);
  //
  //   if (response.isSuccess) {
  //     _taskListModel = TaskListModel.fromJson(response.body!);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(
  //         'Failed to get New Task Data',
  //         style: snackBarText(chipBgColorRed),
  //       )));
  //     }
  //   }
  //   _getNewTaskInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));
    if(response.isSuccess){
      newTaskController.taskListModel.data!.removeWhere((element) => element.sId == taskId);
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

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.updateTaskStatusUrl(taskId, newStatus));
    if(response.isSuccess){
      newTaskController.taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if(mounted){
        setState(() {});
      }
    }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Failed to Update Task Status Data',
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
            newTaskController.getNewTasks();
            //getCountSummary();
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
          newTaskController.getNewTasks();
          getSummaryController.getCountSummary();
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

          GetBuilder<GetSummaryController>(
            builder: (_) {
              if(getSummaryController.getCountSummaryInProgress){
                return const Center(
                  child: LinearProgressIndicator(),
                );
              }
              return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                    height: 70,
                      width: double.infinity,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: getSummaryController.summaryCountModel.data?.length ?? 0,
                          //reverse: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SummaryCard(
                                  number: "${getSummaryController.summaryCountModel.data![index].sum}",
                                  title: getSummaryController.summaryCountModel.data![index].sId ?? '',
                                ),
                              ],
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
          GetBuilder<NewTaskController>(
            builder: (_) {
              return Expanded(
                child: newTaskController.getNewTaskInProgress
                    ? const Center(child: CircularProgressIndicator(),)
                    : RefreshIndicator(
                  onRefresh: () async {
                    newTaskController.getNewTasks();
                  },
                  child: newTaskController.getNewTaskInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: newTaskController.taskListModel.data?.length ?? 0,
                          //reverse: true,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              chipBgColor: chipBgColorBlue,
                              taskStatus: 'New',
                              data: newTaskController.taskListModel.data![index],
                              onDeleteTap: () {
                                deleteTask(newTaskController.taskListModel.data![index].sId!);
                              },
                              onEditTap: () {
                                //showEditBottomSheet(_taskListModel.data![index]);
                                showStatusUpdateBottomSheet(newTaskController.taskListModel.data![index]);
                              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }


}

