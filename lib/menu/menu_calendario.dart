import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String name;
  final String date;

  Event({required this.name, required this.date});
}

class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  State<PantallaCalendario> createState() => _PantallaCalendarioState();
}

class _PantallaCalendarioState extends State<PantallaCalendario> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedEvents = ValueNotifier([]);
    _loadEventsForSelectedDay(_selectedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<List<Event>> _getEventsForDay(DateTime day) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuario no autentificado');
      return [];
    }

    final formattedDate =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('calendar')
            .where('date', isEqualTo: formattedDate)
            .get();

    return snapshot.docs.map((doc) {
      return Event(name: doc['name'], date: doc['date']);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _loadEventsForSelectedDay(selectedDay);
  }

  void _loadEventsForSelectedDay(DateTime day) async {
    final events = await _getEventsForDay(day);
    _selectedEvents.value = events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'CustomFont',
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -400,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/vector18.png',
              width: 600,
              height: 600,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 220),
            child: Column(
              children: [
                TableCalendar<Event>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  eventLoader: (day) => [],
                ),

                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, events, _) {
                      if (events.isEmpty) {
                        return const Center(
                          child: Text('No hay festividades para este día.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: const Color(0xFFEBBCB9),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              title: Text(
                                event.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'CustomFontBold',
                                ),
                              ),
                              subtitle: Text(
                                event.date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'CustomFontBold',
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    final query =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .collection('calendar')
                                            .where(
                                              'name',
                                              isEqualTo: event.name,
                                            )
                                            .where(
                                              'date',
                                              isEqualTo: event.date,
                                            )
                                            .get();

                                    for (var doc in query.docs) {
                                      await doc.reference.delete();
                                    }

                                    _loadEventsForSelectedDay(_selectedDay);
                                  }
                                },
                                icon: const Icon(Icons.delete, color: Colors.black,),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
