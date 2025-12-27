import 'package:get/get.dart';
import '../Models/Activity.dart';
import '../Services/ActivityService.dart';
import 'UserController.dart';

class ActivityController extends GetxController {
  final ActivityService _service = ActivityService();

  var activities = <Activity>[].obs;
  var isLoading = false.obs;

  /// EXISTING METHOD (UNCHANGED)
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

  /// ✅ NEW: CREATE ACTIVITY
  Future<void> createActivity({
    required String title,
    required String description,
    required int classroomId,
  }) async {
    try {
      isLoading(true);

      final userController = Get.find<UserController>();

      final Activity newActivity = await _service.createActivity(
        title: title,
        description: description,
        classroomId: classroomId,
        createdBy: userController.user.value!.id,
      );

      // 🔥 instantly add to list if same classroom
      if (newActivity.classroomId == classroomId) {
        activities.insert(0, newActivity);
      }

      Get.back();
      Get.snackbar("Success", "Activity created successfully");
    } catch (e) {
      print('Create activity failed: $e');
      Get.snackbar("Error", "Failed to create activity");
    } finally {
      isLoading(false);
    }
  }
}
