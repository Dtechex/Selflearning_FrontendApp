import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
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

    final alarmSettings = AlarmSettings(

        id: 42,
        dateTime: localDateTime!, // Replace dateTime with your desired alarm time
        assetAudioPath: 'assets/alarm.mp3', // Path to your audio file
        loopAudio: true, // Whether to loop the audio
        vibrate: true, // Whether to vibrate the device
        volume: 0.8, // Alarm volume (0.0 to 1.0)
        fadeDuration: 3.0, // Duration for audio fade in/out
        notificationTitle: 'This is the title', // Notification title
        notificationBody: 'This is the body', // Notification body
        enableNotificationOnKill: true,
        androidFullScreenIntent: true,// Whether to enable notification on app enableNotificationOnKill
    );

    await Alarm.set(alarmSettings: alarmSettings);
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
          child: Text('OK'),
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
