import 'package:get/get.dart';

class EditProfileController extends GetxController {
  var fullName = 'Alex Johnson'.obs;
  var email = 'alex@example.com'.obs;
  var phoneNumber = '+1 (555) 123-4567'.obs;
  var nationality = 'United States'.obs;
  var isAvatarTapped = false.obs;
  var isCancelTapped = false.obs;
  var isSaveTapped = false.obs;

  void updateFullName(String value) => fullName.value = value;
  void updateEmail(String value) => email.value = value;
  void updatePhoneNumber(String value) => phoneNumber.value = value;
  void updateNationality(String? value) {
    if (value != null) nationality.value = value;
  }

  void onAvatarTap() {
    isAvatarTapped.value = true;
    Future.delayed(Duration(milliseconds: 150), () {
      isAvatarTapped.value = false;
    });
  }

  void onCancelTap() {
    isCancelTapped.value = true;
    Future.delayed(Duration(milliseconds: 150), () {
      isCancelTapped.value = false;
    });
  }

  void onSaveTap() {
    isSaveTapped.value = true;
    Future.delayed(Duration(milliseconds: 150), () {
      isSaveTapped.value = false;
    });
  }
}
