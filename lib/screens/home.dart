// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/adsDisplay.dart';
import 'package:bidhouse/screens/chats.dart';
import 'package:bidhouse/screens/plotInfo.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  late AuthenticationModel userData;
  HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [
    "1 Marla",
    "3 Marla",
    "5 Marla",
    "8 Marla",
    "10 Marla",
    "12 Marla",
    "1 Kanal",
    "2 Kanal",
    "3 Kanal"
  ];

  @override
  Widget build(BuildContext context) {
    Color color = AppConstants.appColor;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: color,
        centerTitle: false,
        title: Text(
          "Hello ${widget.userData.name} ...👋🏻",
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        actions: [
          SizedBox(
            height: 50,
            width: 50,
            child: ClipOval(
              child: (widget.userData.imageUrl != null &&
                      widget.userData.imageUrl!.isNotEmpty)
                  ? Image.network(widget.userData.imageUrl!)
                  : Image.asset(
                      'lib/assets/BidHouse.jpeg',
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'lib/assets/bg1.png',
              ),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Browse",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  AppConstants.button(
                    buttonWidth: 0.3,
                    buttonHeight: 0.05,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdsDisplayScreen(
                            category: "No",
                            userData: widget.userData,
                          ),
                        ),
                      );
                    },
                    buttonText: "Homes",
                    textSize: 17,
                    context: context,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppConstants.button(
                    buttonWidth: 0.4,
                    buttonHeight: 0.05,
                    onTap: () {},
                    buttonText: "Commerical",
                    textSize: 17,
                    context: context,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Popular",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.appColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(15),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final selectedCategory = categories[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdsDisplayScreen(
                                category: selectedCategory,
                                userData: widget.userData),
                          ),
                        );
                      },
                      child: Card(
                        color: AppConstants.bgColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              widget.userData.userType == "User"
                  ? AppConstants.button(
                      buttonWidth: 0.6,
                      buttonHeight: 0.06,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlotInfoScreen(userData: widget.userData),
                          ),
                        );
                      },
                      buttonText: 'Calculate Cost',
                      textSize: 20,
                      context: context,
                    )
                  : Container(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatsScreen(userData: widget.userData),
              ),
            );
          },
          backgroundColor: AppConstants.appColor,
          child: Icon(
            Icons.chat_bubble_outline,
            size: 30,
          ),
        ),
      ),
    );
  }
}
