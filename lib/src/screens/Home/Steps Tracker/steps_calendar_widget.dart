import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../constants/color_constants.dart';
import '../../UserAccount/user_account_provider.dart';
import 'steps_daily_track_provider.dart';

class StepsCalendarWidget extends StatelessWidget {
  const StepsCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userStepsProvider = Provider.of<StepsDailyTrackingProvider>(context);
    final userAccountProvider = Provider.of<UserAccountProvider>(context);
    final currentDate = DateTime.now();

    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: CalendarFormat.week,
      firstDay: userAccountProvider.createdAt,
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: userStepsProvider.selectedDate,
      selectedDayPredicate: (day) => userStepsProvider.isSameDay(userStepsProvider.selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (selectedDay.isBefore(currentDate) || selectedDay.isAtSameMomentAs(currentDate)) {
          userStepsProvider.updateSelectedDate(selectedDay);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected date is in the future. Cannot track steps.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      rowHeight: 40,
      headerVisible: false,
      daysOfWeekHeight: 30,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color:ColorConstants.water,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          shape: BoxShape.circle,
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        disabledDecoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.rectangle,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 14),
        weekendStyle: TextStyle(fontSize: 14),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final isFutureDate = day.isAfter(currentDate);
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: isFutureDate ? Colors.grey : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
