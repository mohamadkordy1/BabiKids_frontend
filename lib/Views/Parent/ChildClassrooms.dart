import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Models/Child.dart';
import '/Models/Classroom.dart';
import '/Services/ChildService.dart';
class ChildClassrooms extends StatefulWidget {
  final Child child;
  const ChildClassrooms({super.key, required this.child});

  @override
  State<ChildClassrooms> createState() => _ChildClassroomsState();
}

class _ChildClassroomsState extends State<ChildClassrooms> {
  var classrooms = <Classroom>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  void fetchClassrooms() async {
    try {
      isLoading.value = true;
      final data = await ChildService.getChildClassrooms(widget.child.id);
      classrooms.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.child.name}'s Classrooms",
            style: GoogleFonts.manrope()),
        backgroundColor: const Color(0xFF0C0E10),
      ),
      backgroundColor: const Color(0xFF0C0E10),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              "Error: ${errorMessage.value}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (classrooms.isEmpty) {
          return const Center(
            child: Text(
              "No classrooms found",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ListView.separated(
              itemCount: classrooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final room = classrooms[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: Navigate to classroom details if needed
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2224),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Color(0xFF3B82F6),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Start: ${room.startTime}, End: ${room.endTime}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFA0A0A0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFFA0A0A0),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}