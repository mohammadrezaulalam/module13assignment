
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project_getx/ui/state_managers/update_user_profile_controller.dart';
import '../style/style.dart';
import '../widgets/app_background.dart';
import '../widgets/user_profile_banner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({super.key});

  @override
  State<UpdateUserProfileScreen> createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final UpdateUserProfileController updateUserProfileController = Get.put(UpdateUserProfileController());
  
  @override
  void initState() {
    super.initState();
    _emailTEController.text = updateUserProfileController.userData?.email ?? '';
    _firstNameTEController.text = updateUserProfileController.userData?.firstName ?? '';
    _lastNameTEController.text = updateUserProfileController.userData?.lastName ?? '';
    _mobileTEController.text = updateUserProfileController.userData?.mobile ?? '';
  }

  File? _photo;

  Future<void> selectImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo == null) return;
    final photoTemporary = File(photo.path);

    setState(() {
      _photo = photoTemporary;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const UserProfileBanner(
                  isUpdateProfileScreen: true,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Update Profile',
                        style: appHeadingText1(colorBlack),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ClipRRect(
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(40),
                              child: _photo != null
                                  ? Image.file(
                                      _photo!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      'https://gcavocats.ca/wp-content/uploads/2018/09/man-avatar-icon-flat-vector-19152370-1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                            prefixIcon: TextButton(
                              style: appTextButtonStyle(),
                              child: const Text(
                                "Photo",
                                style: TextStyle(color: colorWhite),
                              ),
                              onPressed: () {
                                selectImage();
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        decoration: myInputDecoration('Email'),
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _firstNameTEController,
                        decoration: myInputDecoration('First Name'),
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return "First Name Field is Mandatory";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _lastNameTEController,
                        decoration: myInputDecoration('Last Name'),
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return "Last Name Field is Mandatory";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _mobileTEController,
                        decoration: myInputDecoration('Mobile'),
                        keyboardType: TextInputType.phone,
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return "Mobile Field is Mandatory";
                          }else if(value!.length < 11){
                            return "Enter 11 Digit Mobile Number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _passwordTEController,
                        decoration: myInputDecoration('Password'),
                        obscureText: true,
                        validator: (String? value){
                          if((value?.isNotEmpty ?? true) && value!.length < 6){
                            return "Minimum Password Length is 6 Characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: updateUserProfileController.updateUserProfileInProgress == true
                            ? const Center(child: CircularProgressIndicator(),)
                            : ElevatedButton(
                          onPressed: () {
                            if(!_formKey.currentState!.validate()){
                              return;
                            }
                            updateUserProfileController.updateUserProfile(_firstNameTEController.text.trim(), _lastNameTEController.text.trim(), _mobileTEController.text.trim(), _passwordTEController.text).then((result) => {
                              if(result == true){
                                Get.snackbar(
                                  'Success',
                                  'Profile Update Successful',
                                  colorText: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                ),
                              }else{
                                Get.snackbar(
                                  'Success',
                                  'Profile Update Successful',
                                  colorText: Colors.red,
                                  padding: const EdgeInsets.all(15),
                                ),
                              }
                            });
                          },
                          style: appButtonStyle(),
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
