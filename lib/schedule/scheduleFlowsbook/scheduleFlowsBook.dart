import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:self_learning_app/widgets/localNotification.dart';

import '../../features/create_flow/show_prompts_screen.dart';
import '../../features/create_flow/slide_show_screen.dart';
import '../cubit/scheduleflow_cubit.dart';

class ScheduleFlowBook extends StatefulWidget {
  @override
  _ScheduleFlowBookState createState() => _ScheduleFlowBookState();
}

class _ScheduleFlowBookState extends State<ScheduleFlowBook> {
  late Timer _timer;

  @override
  void initState() {
    context.read<ScheduleflowCubit>()..getScheduledFlow();
    startTimer(); // Start the timer
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    // Start a timer that updates the UI every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Update the UI with the current remaining time
      setState(() {});
    });
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toUtc(); // Parse and convert to local timezone
    String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(dateTime); // Format date and time in AM/PM format
    return formattedDateTime;
  }

  String calculateCountdown(String dateString) {
    DateTime selectedTime = DateTime.parse(dateString); // Parse as local time
    var currentTime = DateTime.now();

    // Calculate the difference as a Duration
    Duration difference = selectedTime.difference(currentTime);

    // Check if the duration is negative
    bool isTimerZero = difference.isNegative;

    // Convert the duration to its absolute value
    difference = difference.abs();

    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);
    int seconds = difference.inSeconds.remainder(60);

    // Format the countdown string
    return isTimerZero
        ? 'Time passed'
        : '$days d\n${hours.toString().padLeft(2, '0')} hr ${minutes.toString().padLeft(2, '0')} min\n${seconds.toString().padLeft(2, '0')} sec';
  }

  void alram({ DateTime? dateTime}) async {
    var newdate = dateTime?.toUtc();
    var localDateTime = newdate?.toLocal();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          alram();
          // print("Notification button pressed");
          NotificationService().initNotification();
          NotificationService().showNotification(
            id: 0,
            title: "schedule flow",
            body: "adddd",
            payLoad: "dddd",
          );
        },
        child: Text("Testing Notification"),
      ),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context, true);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Schedule flows"),
      ),
      body: BlocBuilder<ScheduleflowCubit, ScheduleflowState>(
        builder: (context, state) {
          if (state is ScheduleFlowLoading) {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is ScheduleDateLoaded) {
            if (state.dateflowList!.isEmpty) {
              return Center(child: Text("No flow is added"));
            } else {
              debugPrint('Notification Scheduled for ${state.dateflowList![0].dateTime}');
              DateTime dateTime = DateTime.parse(state.dateflowList![0].dateTime!);

              print("date and time$dateTime");
              // alram(dateTime: dateTime);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        int currentIndex = 1 + index;
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the string screen
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    child: Text(currentIndex.toString()),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    state.dateflowList![index].title,
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                                  ),
                                ],
                              ),
                              trailing: calculateCountdown(state.dateflowList![index].dateTime.toString())=="Time passed"?
                              IconButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute( builder: (context) {
                                  return SlideShowScreen(
                                    flowList: state.dateflowList![index].flowList, flowName: state.dateflowList![index].title,
                                  );},));
                              }, icon: Icon(Icons.play_arrow)): Text(
                                calculateCountdown(state.dateflowList![index].dateTime.toString()),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                              subtitle: Container(
                                padding: EdgeInsets.only(left: 35),
                                child: Text(formatDateTime(state.dateflowList![index].dateTime.toString())),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.dateflowList!.length,
                    ),
                  ),
                ],
              );
            }
          }
          if (state is ScheduleFlowError) {
            return Center(child: Text("Server error"));
          }
          return Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
