import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../schedule/cubit/scheduleflow_cubit.dart';
import '../schedule/scheduleFlowsbook/scheduleFlowsBook.dart';
import 'dateTimePicker.dart';

class ScheduleflowScreenWidget extends StatefulWidget {
  const ScheduleflowScreenWidget({super.key});

  @override
  State<ScheduleflowScreenWidget> createState() =>
      _ScheduleflowScreenWidgetState();
}

class _ScheduleflowScreenWidgetState extends State<ScheduleflowScreenWidget> {
  DateTime? currentDate;
  TimeOfDay? currentTime;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    currentTime = TimeOfDay.now();
    context.read<ScheduleflowCubit>().getFlow();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ScheduleFlowBook())).then((value) {
                  setState(() {
                    context.read<ScheduleflowCubit>().getFlow();

                  });
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Schedule Flows"),
          )),
      body: BlocConsumer<ScheduleflowCubit, ScheduleflowState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return BlocBuilder<ScheduleflowCubit, ScheduleflowState>(
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
                  return CustomScrollView(
                    slivers: <Widget>[
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
                                          print("we can see flow id ${state.flowList![index].id}");
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DateTimePickerDialog(
                                                initialDate: currentDate!,
                                                initialTime: currentTime!,
                                                flowId:
                                                    state.flowList![index].id,
                                              );
                                            },
                                          ).then((value) {
                                            setState(() {
                                              context
                                                  .read<ScheduleflowCubit>()
                                                  .getFlow();
                                            });
                                          });
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
                  );
                }
              }
              return Center(child: Text("Some Things went wrong"));
            },
          );
        },
      ),
    );
  }
}
