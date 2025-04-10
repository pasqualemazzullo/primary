import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme/app_colors.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'services/appointment_service.dart';
import 'widgets/month_selector.dart';
import 'widgets/appointment_list.dart';
import 'widgets/custom_calendar.dart';
import 'models/appointment.dart';

class PetCalendarScreen extends StatefulWidget {
  const PetCalendarScreen({super.key});

  @override
  PetCalendarScreenState createState() => PetCalendarScreenState();
}

class PetCalendarScreenState extends State<PetCalendarScreen>
    with WidgetsBindingObserver {
  final AppointmentService _appointmentService = AppointmentService();
  int _selectedIndex = 2;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;
  List<Appointment> _visibleAppointments = [];
  DateTime? _nextAppointmentDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await _appointmentService.loadAppointmentsFromJson();

    final nextDate = _appointmentService.findNextAppointmentDate();

    setState(() {
      _nextAppointmentDate = nextDate;

      if (_selectedDay != null) {
        _visibleAppointments = _appointmentService.getAppointmentsForDay(
          _selectedDay!,
        );
      } else if (nextDate != null) {
        _visibleAppointments = _appointmentService.getAppointmentsForDay(
          nextDate,
        );
      } else {
        _visibleAppointments = [];
      }

      _isLoading = false;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMonthSelected(int month) {
    setState(() {
      _currentMonth = month;
      _focusedDay = DateTime(_currentYear, month, 1);
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _visibleAppointments = _appointmentService.getAppointmentsForDay(
        selectedDay,
      );
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _currentMonth = focusedDay.month;
      _currentYear = focusedDay.year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.orange,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchBarWidget(
                      onSearchChanged: (_) {},
                      onAppointmentAdded: () {
                        _loadData();
                      },
                      screenIndex: _selectedIndex,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppointmentList(
                          appointments: _visibleAppointments,
                          selectedDay: _selectedDay,
                          nextAppointmentDate: _nextAppointmentDate,
                          onAppointmentChanged: _loadData,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  MonthSelector(
                    currentMonth: _currentMonth,
                    onMonthSelected: _onMonthSelected,
                  ),

                  _isLoading
                      ? Container(
                        height: MediaQuery.of(context).size.height - 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: AppColors.orange,
                        ),
                      )
                      : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomCalendar(
                          focusedDay: _focusedDay,
                          selectedDay: _selectedDay,
                          calendarFormat: _calendarFormat,
                          eventDays: _appointmentService.eventDays,
                          onDaySelected: _onDaySelected,
                          onFormatChanged: _onFormatChanged,
                          onPageChanged: _onPageChanged,
                        ),
                      ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onNavItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}
