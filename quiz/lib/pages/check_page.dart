import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/question_widget.dart';
import '../utils/responsive.dart';

class CheckPage extends StatefulWidget {
  const CheckPage(
      {super.key, required this.score, required this.selectedOptions});

  final int score;
  final Map<int, String> selectedOptions;

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final List<Map<String, dynamic>>? quiz = GlobalUser().quiz;
  PageController _pageController = PageController();
  // Map<int, String> selectedOptions = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: Responsive.heightUnit * 20,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Your Score: ${widget.score}/${quiz!.length}',
              style: TextStyle(
                fontSize: Responsive.scale * 9,
                fontWeight: FontWeight.w800,
                color: AppColors.tertiary,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: (){
              Navigator.pop(context);
            },
          )
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.widthUnit * 5, vertical: Responsive.heightUnit * 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (quiz == null)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: quiz!.length,
                    itemBuilder: (context, index) {
                      return QuestionCheckWidget(
                        questionData: quiz![index],
                        index: index,
                        totalQuestions: quiz!.length,
                        selectedOption: widget.selectedOptions[index] ?? "",
                      );
                    },
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  final isLastPage = _pageController.page?.round() == quiz!.length - 1;

                  if (!isLastPage) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                  else{
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: AppColors.primary)),
                  padding: EdgeInsets.symmetric(
                    vertical: Responsive.heightUnit * 4,
                    horizontal: Responsive.widthUnit * 12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _pageController.hasClients &&
                          _pageController.page?.round() == quiz!.length - 1
                          ? "Done"
                          : "Next",
                      style: TextStyle(
                          fontSize: Responsive.scale * 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'OpenSans',
                          color: AppColors.primary),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      _pageController.hasClients &&
                          _pageController.page?.round() == quiz!.length - 1
                          ? Icons.check
                          : Icons.arrow_right_alt_sharp,
                      color: AppColors.primary,
                      size: 30,
                    ),
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
