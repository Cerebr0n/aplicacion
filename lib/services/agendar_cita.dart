import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; //<== dependencias / table_calendar: ^3.2.0

//esta clase muestra el calendario y horarios disponibles ese mismo dia
class CitaScreen extends StatefulWidget {
  const CitaScreen({super.key});

  @override
  State<CitaScreen> createState() => _CitaScreenState();
}

class _CitaScreenState extends State<CitaScreen> {
   DateTime _focusedDay = DateTime.now();
   DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
        title: const Row(
          children: [
            Icon(Icons.bloodtype, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('HematoLab', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}