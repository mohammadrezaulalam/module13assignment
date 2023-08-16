import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/summary_count_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class GetSummaryController extends GetxController{
  bool _getCountSummaryInProgress = false;
  bool get getCountSummaryInProgress => _getCountSummaryInProgress;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  SummaryCountModel get summaryCountModel => _summaryCountModel;

  Future<bool> getCountSummary() async {
    _getCountSummaryInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.taskStatusCountUrl);
    _getCountSummaryInProgress = false;
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
      return true;
    } else {
      update();
      return false;
    }
  }
}