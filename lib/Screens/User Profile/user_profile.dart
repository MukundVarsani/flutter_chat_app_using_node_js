import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Screens/User%20Profile/common/list_tile.dart';
import 'package:chat_app_with_backend/Services/uploade_profile.dart';
import 'package:chat_app_with_backend/Services/user_service.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  static const List<String> _list = [
    'Edit Profile',
    "My Stats",
    "Settings",
    "Invite a friend" "Help",
    "Help"
  ];
  static const List<IconData> _icons = [
    Icons.person,
    Icons.business,
    Icons.settings,
    Icons.person_add,
    Icons.help,
  ];

  static const List<Color> _color = [
    Colors.indigo,
    Colors.greenAccent,
    Colors.red,
    Colors.blue,
    Colors.orangeAccent
  ];

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  
  XFile? imgFile;
  Uint8List? img;
  late ImageService _imageService;
  late UserService _userService;
   UserModel user = UserModel();

  String bits = '';
  Uint8List? userimage;
  @override
  void initState() {
    
    _imageService = ImageService();
    _userService = UserService();
    profileImage();
    super.initState();
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    imgFile = await picker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      img = await imgFile!.readAsBytes();
      setState(() {
        bits = base64Encode(io.File(imgFile!.path).readAsBytesSync());
      });
      String userId = await Utils.getUserId();

      String res = await _imageService.updateProfile(img: bits, userId: userId);
      profileImage();

          if(res.isNotEmptyAndNotNull){
            
      VxToast.show(context, msg: res.toString(),position: VxToastPosition.center);
          }
    }
  }

  void profileImage() async {
    String userId = await Utils.getUserId();
    UserModel? res = await _userService.getUser(userId);

    if (res != null) {
      user = res;
    }

    if (user.image.isNotEmptyAndNotNull) {
      userimage = base64Decode(user.image!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.8),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(0.8),
        child: 
               Column(
                children: [

                  (user.name != null) ? 
                  Column(
                    children: [
                      const HeightBox(10),
                      Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.white30,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    blurStyle: BlurStyle.normal)
                              ],
                              borderRadius: BorderRadius.circular(500),
                              border: Border.all(
                                  width: 3,
                                  color: Colors.black.withOpacity(0.6))),
                          child: (user.name != null) ?  ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: (img != null)
                                  ? Image.memory(img!)
                                  : (userimage != null)
                                      ? Image.memory(userimage!, fit: BoxFit.cover,)
                                      : Image.network(
                                          fit: BoxFit.cover,
                                          'https://img.freepik.com/free-photo/freedom-concept-with-hiker-mountain_23-2148107064.jpg')): 
                                          const SizedBox()
                        ),
                        Positioned(
                            bottom: 7,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () => _pickImage(),
                            )),
                      ]),
                      Text(
                        user.name ?? "Null",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        user.email ?? "Null",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ):

                 const SizedBox( height: 200,child:  Center(child: CircularProgressIndicator.adaptive())),
                  const HeightBox(50),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.78),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => ProfileList(
                                color: UserProfile._color[index],
                                content: UserProfile._list[index],
                                icon: UserProfile._icons[index],
                              )),
                    ),
                  )
                ],
             
      ),
    ),
    );
  }
}
