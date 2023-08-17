import 'package:get/get.dart';

import '../../data/models/auth_utility.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class UpdateUserProfileController extends GetxController{

  bool _updateUserProfileInProgress = false;
  bool get updateUserProfileInProgress => _updateUserProfileInProgress;
  final UserData _userData = AuthUtility.userInfo.data!;
  UserData get userData => _userData;
  Future<bool> updateUserProfile(String firstName, String lastName, String mobile, [String password = '']) async {
    _updateUserProfileInProgress = true;
    print(_updateUserProfileInProgress);
    update();

    final Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };
    if(password.isNotEmpty){
      requestBody['password'] = password;
    }

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.userProfileUpdateUrl, requestBody);
    _updateUserProfileInProgress = false;
    update();
    if(response.isSuccess){
      userData.firstName = firstName;
      userData.lastName = lastName;
      userData.mobile = mobile;
      AuthUtility.updateUserInfo(userData);
      return true;
    }else{
      return false;
    }

  }


}