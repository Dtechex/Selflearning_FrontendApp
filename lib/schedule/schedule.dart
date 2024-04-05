import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/schedule/scheduleFlowsbook/scheduleFlowsBook.dart';

import '../features/create_flow/data/model/flow_model.dart';
import '../widgets/dateTimePicker.dart';
import 'cubit/scheduleflow_cubit.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  DateTime? currentDate;
  TimeOfDay? currentTime;
  List<FlowModel> filteredList = [];

// Inside your State class

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    currentTime = TimeOfDay.now();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ScheduleflowCubit()..getFlow(),
      child: BlocBuilder<ScheduleflowCubit, ScheduleflowState>(
        builder: (context, state) {
          if (state is ScheduleFlowLoading) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          if (state is ScheduleFlowLoaded) {
            if (state.flowList == 0 || state.flowList!.isEmpty) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Center(child: Text("!No flows ")),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.grey.shade100,
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      title: BlurryContainer(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                        elevation: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  // Handle text changes here
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                style: TextStyle(color: Colors.black),
                                autocorrect: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.grey.shade100,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the string screen
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              height: 70,
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      state.flowList![index].title,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DateTimePickerDialog(
                                              initialDate: currentDate!,
                                              initialTime: currentTime!,
                                              flowId: state.flowList![index].id,
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.calendar_month),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.flowList!.length,
                      ),
                    ),
                  ],
                ),
                floatingActionButton: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleFlowBook()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Schedule Flows"),
                  )
                ),
              );
            }
          }
          return Text("Some Things went wrong");
        },
      ),
    );
  }

}
