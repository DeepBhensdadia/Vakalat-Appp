import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vakalat_flutter/New%20UI/Services/services_screen.dart';
import 'package:vakalat_flutter/api/web_service.dart';
import 'package:vakalat_flutter/utils/design.dart';

import '../../Sharedpref/shared_pref.dart';
import '../../color/customcolor.dart';
import '../../helper.dart';
import '../../model/AddServicesModel.dart';
import '../../model/AddServicesResponceModel.dart';
import '../../model/clsLoginResponseModel.dart';
import '../../utils/constant.dart';

class Add_Services extends StatefulWidget {
  const Add_Services({Key? key}) : super(key: key);

  @override
  State<Add_Services> createState() => _Add_ServicesState();
}

class _Add_ServicesState extends State<Add_Services> {
  File? profilepic;

  Future<void> pickimage() async {
    XFile? Selectedimage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (Selectedimage != null) {
      File convertedFile = File(Selectedimage.path);
      setState(() {
        profilepic = convertedFile;
      });

      Fluttertoast.showToast(msg: "Image Selected");
    } else {
      Fluttertoast.showToast(msg: "Image Not Selected");
    }
  }

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController Amountcontroller = TextEditingController();
  TextEditingController Detailscontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Services',
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: CustomColor().colorPrimary,
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          CustomTextfield(
            labelname: 'Enter Title',
            Controller: titlecontroller,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "please enter title";
              }
              return null;
            },
          ),
          CustomTextfield(
              labelname: 'Enter Amount', Controller: Amountcontroller,validator: (p0) {
            if (p0!.isEmpty) {
              return "please enter amount";
            }
            return null;
          },),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: InkWell(
              onTap: () {
                pickimage();
              },
              child: Container(
                height: 50,
                width: screenwidth(context, dividedby: 1),
                decoration: Const().decorationfield,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        profilepic != null ? 'Image Selected' : 'Upload Image',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            pickimage();
                          },
                          child: const Icon(FontAwesomeIcons.add, size: 16))
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomTextfield(
            maxline: 5,
              labelname: 'Enter Details', Controller: Detailscontroller,validator: (p0) {
            if (p0!.isEmpty) {
              return "please enter details";
            }
            return null;
          },),
          Button_For_Update_Save(
            text: 'Update',
            onpressed: () {
              if (_formKey.currentState!.validate()) {
                add_services.call();
              }
            },
          ),
        ]),
      ),
    );
  }

  final WebService _webService = WebService();
  Future<void> add_services() async {
    if (profilepic != null) {
      ClsLoginResponseModel logindetails = clsLoginResponseModelFromJson(
          SharedPref.get(prefKey: PrefKey.loginDetails)!);
      EasyLoading.show(status: 'Loading...');

      AddServicesDataModel addServicesDataModel = AddServicesDataModel(
          title: titlecontroller.text,
          accessToken: logindetails.accessToken,
          amount: Amountcontroller.text,
          apiKey: apikey,
          detail: Detailscontroller.text,
          device: device,
          smImage: profilepic?.path,
          userId: logindetails.userData.userId);

      String uri = ('https://www.vakalat.com/user_api/Add_service');

      final Response response = await _webService.postFormRequest(
        url: uri,
        formData: await addServicesDataModel.toFormData(),
      );
      AddServicesResponceModel servi =
          addServicesResponceModelFromJson(response.data);
      // AddServicesResponceModel jasondata = response.data;
      debugPrint(JsonEncoder.withIndent(" " * 4).convert(response.data),
          wrapWidth: 100000);
      // AddServicesResponceModel? addservices;
      if (response.statusCode == 200) {
        // late clsAddServicesResponseModel addservices;
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: servi.message);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Services_screen(),
            ));
        print('image uploaded');
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: servi.message);

        print('failed');
      }
    } else {
      Fluttertoast.showToast(msg: 'plz Select Image');
    }
  }
}
