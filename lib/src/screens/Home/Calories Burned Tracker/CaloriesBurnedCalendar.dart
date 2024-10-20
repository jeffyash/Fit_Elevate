import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../constants/color_constants.dart';
import '../../UserAccount/user_account_provider.dart';
import 'CaloriesBurnedProvider.dart';
class CaloriesBurnedCalendar extends StatelessWidget {
  const CaloriesBurnedCalendar({super.key});
  @override
  Widget build(BuildContext context) {
    final caloriesBurnedProvider = Provider.of<CaloriesBurnedProvider>(context);
    final userAccountProvider = Provider.of<UserAccountProvider>(context);
    final currentDate = DateTime.now();
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: CalendarFormat.week,
      firstDay: userAccountProvider.createdAt,
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: caloriesBurnedProvider.selectedDate,
      selectedDayPredicate: (day) =>
          caloriesBurnedProvider.isSameDay(caloriesBurnedProvider.selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        // Check if the selected day is not in the future
        if (selectedDay.isBefore(currentDate) || selectedDay.isAtSameMomentAs(currentDate)) {
          caloriesBurnedProvider.updateSelectedDate(selectedDay);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected date is in the future. Cannot track water intake.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      rowHeight: 40,
      headerVisible: false,  // Removes the header from the calendar
      daysOfWeekHeight: 30,  // Adjusts the height of the weekdays row
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: ColorConstants.water,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: ColorConstants.water,
          shape: BoxShape.circle,
        ),
        // Optionally change the appearance of future dates
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        disabledDecoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.rectangle,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 14,
        ),
        weekendStyle: TextStyle(
          fontSize: 14,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final isFutureDate = day.isAfter(currentDate);
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),  // Adds space above the date cells
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
