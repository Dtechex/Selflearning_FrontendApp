
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../schedule/cubit/scheduleflow_cubit.dart';
import 'localNotification.dart';

class DateTimePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final String ? flowId;

  DateTimePickerDialog({required this.initialDate, required this.initialTime, required this.flowId});

  @override
  _DateTimePickerDialogState createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  void alram({ DateTime? dateTime}) async {
    var newdate = dateTime?.toUtc();
    var localDateTime = newdate?.toLocal();

  }


  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
    selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.parse("2024-04-09 12:50:00.000");
    alram(dateTime: time);
    print('we can check time $time');

    return AlertDialog(
      title: Row(
        children: [
          Text('Select Date and Time'),
          SizedBox(width: 10,),
          Icon(Icons.watch_later_outlined)
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                width: 1.5,
                color: Colors.grey.shade200
              )
            ),
            child: ListTile(
              title: Text('Date',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.8))),
              subtitle: Text('${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}',style: TextStyle(color: Colors.green),),

              onTap: _pickDate,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade200
                )
            ),
            child: ListTile(
              title: Text('Time',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.8))),
              subtitle: Text('${selectedTime?.hour}:${selectedTime?.minute}',style: TextStyle(color: Colors.green)),
              onTap: _pickTime,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (selectedDate != null && selectedTime != null) {
              DateTime scheduledDateTime = DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime!.hour,
                selectedTime!.minute,
              );
              print("scheduledDateTime---${scheduledDateTime}");
              alram(dateTime: scheduledDateTime);
              // NotificationService().scheduleNotification(
              //     scheduledNotificationDateTime: scheduledDateTime,
              //     timeZoneIdentifier: "Asia/Kolkata"
              // );

              context.read<ScheduleflowCubit>().addDateTime(
                scheduledDateTime: scheduledDateTime,
                flowId: widget.flowId.toString(),
              );
              Navigator.of(context).pop(true);
            } else {
              // Handle case where date or time is not selected
            }
          },
          child: Text("Schedule flow"),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}
