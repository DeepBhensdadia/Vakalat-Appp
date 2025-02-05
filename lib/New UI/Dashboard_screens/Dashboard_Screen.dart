import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vakalat_flutter/Sharedpref/shared_pref.dart';
import 'package:vakalat_flutter/model/GetDashboard.dart';
import 'package:vakalat_flutter/model/Get_Profile.dart';

import '../../api/postapi.dart';
import '../../color/customcolor.dart';
import '../../model/clsLoginResponseModel.dart';
import '../../pages/dashboard.dart';
import '../../utils/constant.dart';
import '../Drawer/Drawer_screen.dart';
import 'Inquiries.dart';
import 'Jobs/Jobs_Main.dart';
import 'Joined_Event.dart';
import 'Your_Videos.dart';
import 'latest_case.dart';

class DashBoard_Screen extends StatefulWidget {
  final Getdashboard data;
  const DashBoard_Screen({Key? key, required  this.data}) : super(key: key);

  @override
  State<DashBoard_Screen> createState() => _DashBoard_ScreenState();
}

class _DashBoard_ScreenState extends State<DashBoard_Screen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  // GetProfileModel getprofile = getProfileModelFromJson(SharedPref.get(prefKey: PrefKey.getProfile)!);
  ClsLoginResponseModel? loginDetails = SharedPref.get(prefKey: PrefKey.loginDetails) != null
      ? clsLoginResponseModelFromJson(SharedPref.get(prefKey: PrefKey.loginDetails)!)
      : null;
  Future<void> get_services() async {
    Map<String, dynamic> parameters = {
      "apiKey": apikey,
      'device': '2',
      "accessToken": loginDetails!.accessToken,
      "user_id": loginDetails!.userData.userId,
      "offset": "0",
    };
    EasyLoading.show(status: 'Loading...');
    await Get_Services(body: parameters).then((value) {

      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(title: ''),));
      msgexpire;
      Const().deleteprofilelofinandmenu();
      EasyLoading.dismiss();
    });
  }
  get_profile_forsave() async {
    if(loginDetails!.userData.userId.isNotEmpty){
      get_services();
      Map<String, dynamic> parameters = {
        "apiKey": apikey,
        'device': '2',
        "user_id":loginDetails!.userData.userId
      };
      EasyLoading.show(status: 'Loading...');
      await get_profile(body: parameters).then((value) async {
        await SharedPref.save(
            value: jsonEncode(value.toJson()),
            prefKey: PrefKey.getProfile);
        EasyLoading.dismiss();
      }).onError((error, stackTrace) {
        // ToastMessage().showmessage(error.toString());
        print(error);
        EasyLoading.dismiss();
      });
    }
  }


  @override
  void initState() {
    get_profile_forsave();
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this,initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Tab> tabs = <Tab>[
    const Tab(child: Text("Latest Case")),
    const Tab(child: Text("Inquiries")),
    const Tab(child: Text("Joined Event")),
    const Tab(child: Text("Jobs")),
    const Tab(child: Text("Your Videos")),
    // const Tab(child: Text("Known Language")),
    // const Tab(child: Text("Change Password")),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
          drawer: const Drawer(
            child: Drawer_Screen(),
          ),
          appBar: AppBar(
            title: const Text(
              'DashBoard',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            backgroundColor: CustomColor().colorPrimary,
         leading: Builder(builder: (context) => IconButton(onPressed: (){

           Scaffold.of(context).openDrawer();
         }, icon: const Icon(FontAwesomeIcons.bars)),),
            automaticallyImplyLeading: false,
            // actions: [
            //   // Live session blink icon
            //   TextButton(onPressed: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',),));
            //   }, child: Text('Login'))
            //
            // ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 45,
                child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(color:CustomColor().colorPrimary.withOpacity(0.1) ,borderRadius: BorderRadius.circular(5)),
                    unselectedLabelColor: CustomColor().colorLightGray,
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    labelColor: CustomColor().colorPrimary,
                    tabs: tabs
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children:   [
                    Latest_Case(value : widget.data),
                    Latest_Inquiries(value : widget.data),
                    Joined_Event(value : widget.data),
                    Jobs_Main(value : widget.data),
                    your_Videos(value : widget.data),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
