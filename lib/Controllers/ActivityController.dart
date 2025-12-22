import 'package:get/get.dart';
import '../Models/Activity.dart';
import '../Services/ActivityService.dart';

class ActivityController extends GetxController {
  final ActivityService _service = ActivityService();

  var activities = <Activity>[].obs;
  var isLoading = false.obs;

  Future<void> loadActivitiesForClass(int classroomId) async {
    try {
      isLoading(true);

      final allActivities = await _service.fetchActivities();

      activities.value = allActivities
          .where((a) => a.classroomId == classroomId)
          .toList();
    } catch (e) {
      print('Failed to load activities: $e');
    } finally {
      isLoading(false);
    }
  }
}
