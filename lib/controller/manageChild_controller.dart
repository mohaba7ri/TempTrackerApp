
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temp_tracker/widgets/custom_toast.dart';

class ManageChildController extends GetxController {



     @override
  void onInit() async {
    super.onInit();

fetchChildren() ;
  }

    var childID = Get.arguments;

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController nameC = TextEditingController();
    TextEditingController ageC = TextEditingController();
  TextEditingController emgNameC = TextEditingController();
  TextEditingController emgPhoneC = TextEditingController();
  TextEditingController tempC = TextEditingController();
 var isLoading = false.obs;


 void Clear(){
   nameC.clear();
      ageC.clear();
      emgNameC.clear();
      emgPhoneC.clear();
      tempC.clear();
 }

void updateChild() {
   double temperature = double.parse(tempC.text);
   if (temperature <= 37 ){
  isLoading = true.obs;

  if (nameC.text.isEmpty ||
      ageC.text.isEmpty ||
      emgNameC.text.isEmpty ||
      emgPhoneC.text.isEmpty ||
      tempC.text.isEmpty) {
    CustomToast.errorToast('Please fill in all fields');
    return;
  }

  databaseReference.child(childID).update({
    'name': nameC.text,
    'age': ageC.text,
    'emergName': emgNameC.text,
    'emergPhone': emgPhoneC.text,
    'temperature': tempC.text,
  }).then((value) {
    isLoading = false.obs;
    CustomToast.successToast('Updated Child successfully');
    Clear();
  }).catchError((error) {
    isLoading = false.obs;
    // Handle error
    CustomToast.errorToast('Error updating child: $error');
  });
   }
   else {
      CustomToast.errorToast('Temperature is higher than normal!');
   }
}







   void fetchChildren() async {
          databaseReference = FirebaseDatabase.instance.ref().child('Children');
 DataSnapshot snapshot = await databaseReference.child(childID).get();
 
    Map child = snapshot.value as Map;
 
    nameC.text = child['name'];
    ageC.text = child['age'];
    emgNameC.text = child['emergName'];
     emgPhoneC.text = child['emergPhone'];
          tempC.text = child['temperature'];

}

}
